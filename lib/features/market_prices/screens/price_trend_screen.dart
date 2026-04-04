import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/market_price_provider.dart';
import '../widgets/market_widgets.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class PriceTrendScreen extends ConsumerWidget {
  const PriceTrendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final crop = ref.watch(marketSelectedCropProvider);
    final market = ref.watch(selectedMarketPriceProvider);
    final trendAsync = ref.watch(marketTrendProvider);

    if (crop == null || market == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FBF9),
        appBar: AppBar(title: Text(l10n.priceTrendsTitle), backgroundColor: const Color(0xFFF9FBF9), elevation: 0),
        body: Center(child: Text(l10n.noDataBound)),
      );
    }

    final translatedCropName = L10nUtils.translateCrop(context, crop.name);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: Text(l10n.cropTrends(translatedCropName), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: trendAsync.when(
        data: (trends) {
          if (trends.isEmpty) return Center(child: Text(l10n.noHistoricalTrends));
          bool isRising = trends.last.price > trends.first.price;
          final color = isRising ? AppColors.primaryGreen : Colors.redAccent;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMarketHeader(market.marketName, l10n.historicalTrendsDesc),
                      const SizedBox(height: 32),
                      PriceTrendChart(data: trends),
                      const SizedBox(height: 48),
                      _buildInsightCard(isRising, color, l10n, translatedCropName),
                      const SizedBox(height: 60),
                    ],
                  ),
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

  Widget _buildMarketHeader(String name, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Text(desc, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: -0.5)),
      ],
    );
  }

  Widget _buildInsightCard(bool isRising, Color color, AppLocalizations l10n, String cropName) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 30, offset: const Offset(0, 15))],
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(isRising ? Icons.trending_up_rounded : Icons.trending_down_rounded, color: color, size: 48),
          ),
          const SizedBox(height: 24),
          Text(
            isRising ? l10n.pricesRising.toUpperCase() : l10n.pricesDipping.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 13, letterSpacing: 2),
          ),
          const SizedBox(height: 16),
          Text(
            isRising ? l10n.sellSuggestion(cropName) : l10n.holdSuggestion(cropName),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87, letterSpacing: -0.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            isRising ? 'Current trend indicates high demand. Secure your profits now.' : 'Wait for market recovery. Prices are expected to stabilize soon.',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13, height: 1.5, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
