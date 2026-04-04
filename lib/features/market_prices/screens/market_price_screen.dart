import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/market_price_provider.dart';
import '../widgets/market_widgets.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class MarketPriceScreen extends ConsumerWidget {
  const MarketPriceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final crop = ref.watch(marketSelectedCropProvider);
    final pricesAsync = ref.watch(marketPricesProvider);

    if (crop == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FBF9),
        appBar: AppBar(title: Text(l10n.marketPricesTitle), backgroundColor: const Color(0xFFF9FBF9), elevation: 0),
        body: Center(child: Text(l10n.noCropSelected)),
      );
    }

    final translatedCropName = L10nUtils.translateCrop(context, crop.name);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: Text(l10n.cropPrices(translatedCropName), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: pricesAsync.when(
        data: (prices) {
          if (prices.isEmpty) return Center(child: Text(l10n.noMarketData));
          int maxModalPrice = 0;
          for (var p in prices) {
            if (p.modalPrice > maxModalPrice) maxModalPrice = p.modalPrice;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.compare_arrows_rounded, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(l10n.comparePricesLabel.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  physics: const BouncingScrollPhysics(),
                  itemCount: prices.length,
                  itemBuilder: (context, index) {
                    final priceData = prices[index];
                    final isHighest = priceData.modalPrice == maxModalPrice;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: MarketPriceRow(
                        priceData: priceData,
                        isHighestPrice: isHighest,
                        onTap: () {
                          ref.read(selectedMarketPriceProvider.notifier).setMarketPrice(priceData);
                          context.push('/market-prices/detail');
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
