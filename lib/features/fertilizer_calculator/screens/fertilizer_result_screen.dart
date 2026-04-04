import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../providers/fertilizer_provider.dart';
import '../widgets/cards.dart';
import '../models/soil_model.dart';
import '../models/fertilizer_model.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';

class FertilizerResultScreen extends ConsumerWidget {
  const FertilizerResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final recommendationAsync = ref.watch(recommendationProvider);
    final isOrganicMode = ref.watch(organicModeProvider);
    final soilData = ref.watch(currentSoilDataProvider);

    if (soilData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FBF9),
        appBar: AppBar(title: Text(l10n.resultsTitle), backgroundColor: const Color(0xFFF9FBF9), elevation: 0),
        body: Center(child: Text(l10n.noComputingData)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: Text(l10n.recommendationReport, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: recommendationAsync.when(
        data: (data) {
          if (data == null) return Center(child: Text(l10n.failedToCalculate));
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderDetails(context, soilData, l10n),
                      const SizedBox(height: 32),
                      _buildSectionLabel(l10n.soilAnalysisStatus),
                      Row(
                        children: [
                          Expanded(child: _buildNutrientMetric('N', L10nUtils.translateSoilStatus(context, data.analysis.nitrogenLevel.name), Colors.blue)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildNutrientMetric('P', L10nUtils.translateSoilStatus(context, data.analysis.phosphorusLevel.name), Colors.orange)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildNutrientMetric('K', L10nUtils.translateSoilStatus(context, data.analysis.potassiumLevel.name), Colors.purple)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildModeToggle(context, ref, isOrganicMode, l10n),
                      const SizedBox(height: 32),
                      _buildSectionLabel(isOrganicMode ? l10n.organicSuggestions : l10n.chemicalSuggestions),
                      _buildRecommendationList(context, data, isOrganicMode, l10n),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
        error: (err, _) => Center(child: Text('${l10n.errorLabel}: $err')),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5)),
    );
  }

  Widget _buildHeaderDetails(BuildContext context, SoilData data, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(L10nUtils.translateCrop(context, data.crop.toLowerCase()), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(l10n.landAreaLabel(data.area.toString(), data.unit == 'Acre' ? l10n.unitAcre : l10n.unitHectare), style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientMetric(String label, String level, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5)),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 24)),
          const SizedBox(height: 8),
          Text(level.toUpperCase(), style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildModeToggle(BuildContext context, WidgetRef ref, bool isOrganic, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)]),
      child: Row(
        children: [
          _toggleButton(context, ref, true, isOrganic, Icons.eco_rounded, l10n.organicMode, AppColors.primaryGreen),
          _toggleButton(context, ref, false, !isOrganic, Icons.science_rounded, l10n.chemicalMode, Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _toggleButton(BuildContext context, WidgetRef ref, bool target, bool isActive, IconData icon, String label, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isActive) ref.read(organicModeProvider.notifier).toggle();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: isActive ? color : Colors.transparent, borderRadius: BorderRadius.circular(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isActive ? Colors.white : Colors.grey.shade400, size: 18),
              const SizedBox(width: 10),
              Text(label.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: isActive ? Colors.white : Colors.grey.shade400, letterSpacing: 1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationList(BuildContext context, RecommendationResponse data, bool isOrganic, AppLocalizations l10n) {
    final List<FertilizerRecommendation> items = isOrganic ? data.organic : data.chemical;
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
        child: Column(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
            const SizedBox(height: 24),
            Text(l10n.sufficientNutrients, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.green)),
            const SizedBox(height: 8),
            const Text('Your soil is perfectly balanced for this crop.', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      );
    }
    return Column(children: items.map((item) => FertilizerCard(rec: item)).toList());
  }
}
