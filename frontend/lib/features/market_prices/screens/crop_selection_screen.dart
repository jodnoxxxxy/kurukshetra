import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/market_price_provider.dart';
import '../widgets/market_widgets.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';

class MarketCropSelectionScreen extends ConsumerWidget {
  final bool isEmbedded;
  const MarketCropSelectionScreen({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cropsAsync = ref.watch(marketCropsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.marketPricesTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: cropsAsync.when(
        data: (crops) {
          // Group by category
          final Map<String, List<dynamic>> categorical = {};
          for (var c in crops) {
            categorical.putIfAbsent(c.category, () => []).add(c);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: categorical.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(L10nUtils.translateCategory(context, entry.key), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      final crop = entry.value[index];
                      return MarketCropCard(
                        crop: crop,
                        onTap: () {
                          ref.read(marketSelectedCropProvider.notifier).setCrop(crop);
                          context.push('/market-prices/list');
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
