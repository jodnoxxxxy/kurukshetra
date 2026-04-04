import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import '../providers/soil_provider.dart';

class SoilRecommendationScreen extends ConsumerWidget {
  const SoilRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organicRecsAsync = ref.watch(organicRecommendationsProvider);
    final cropSuggsAsync = ref.watch(cropSuggestionsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.organicStrategy, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.spa, color: AppColors.primaryGreen, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.soilPracticeInstruction,
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.organicFertilizerSolutions,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            organicRecsAsync.when(
              data: (recs) {
                if (recs.isEmpty) return Text(l10n.perfectSoilHealth);
                return Column(
                  children: recs.map((rec) => _buildOrganicRecCard(rec)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('${l10n.error}: $err')),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.idealCropVariations,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            cropSuggsAsync.when(
              data: (crops) {
                if (crops.isEmpty) return Text(l10n.noSpecificCrops);
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: crops.map((c) => _buildCropChip(context, c)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('${l10n.error}: $err')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganicRecCard(dynamic rec) {
    IconData icon = Icons.grass;
    if (rec.iconName == 'eco') icon = Icons.eco;
    if (rec.iconName == 'compost') icon = Icons.compost;
    if (rec.iconName == 'science') icon = Icons.science;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(rec.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            ...rec.suggestions.map<Widget>((dynamic sugg) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 4), child: Icon(Icons.circle, size: 8, color: Colors.blueGrey)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(sugg, style: TextStyle(color: Colors.grey.shade800))),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCropChip(BuildContext context, String cropName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.psychology_alt, color: Colors.amber, size: 18),
          const SizedBox(width: 8),
          Text(
            L10nUtils.translateCropName(context, cropName),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900),
          ),
        ],
      ),
    );
  }
}
