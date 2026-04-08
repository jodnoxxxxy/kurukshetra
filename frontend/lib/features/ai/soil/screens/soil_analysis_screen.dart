import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import '../providers/soil_provider.dart';
import '../widgets/soil_widgets.dart';

class SoilAnalysisScreen extends ConsumerWidget {
  const SoilAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysis = ref.watch(currentSoilAnalysisProvider);
    final l10n = AppLocalizations.of(context)!;

    if (analysis == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FBF9),
        appBar: AppBar(title: Text(l10n.error), backgroundColor: const Color(0xFFF9FBF9), elevation: 0),
        body: Center(child: Text(l10n.noDataComputed)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: Text(l10n.soilAnalysisStatus, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SoilHealthScoreGauge(score: analysis.healthScore),
                  const SizedBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 20),
                    child: Text(
                      l10n.detailedMacronutrients.toUpperCase(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5),
                    ),
                  ),
                  SoilStatusCard(label: l10n.nutrientStatus(l10n.nitrogenLabel), category: analysis.nitrogen),
                  SoilStatusCard(label: l10n.nutrientStatus(l10n.phosphorusLabel), category: analysis.phosphorus),
                  SoilStatusCard(label: l10n.nutrientStatus(l10n.potassiumLabel), category: analysis.potassium),
                  SoilStatusCard(label: l10n.phLevelLabel, category: analysis.phLevel),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/soil-health/recommendations'),
                      icon: const Icon(Icons.eco_rounded),
                      label: Text(l10n.viewOrganicRecommendations.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primaryGreen.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
