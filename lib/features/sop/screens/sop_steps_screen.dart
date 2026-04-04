import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../providers/sop_provider.dart';

import 'package:kurukshetra/core/utils/l10n_utils.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class SopStepsScreen extends ConsumerWidget {
  const SopStepsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final crop = ref.watch(selectedSopCropProvider);
    final sopDataAsync = ref.watch(sopStepsProvider);

    if (crop == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.sopTitle)),
        body: Center(child: Text(l10n.selectCropFirst)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(l10n.cropSopTitle(L10nUtils.translateCrop(context, crop.name.toLowerCase())), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => context.push('/chat'),
            tooltip: l10n.aiSopAssistant,
          ),
        ],
      ),
      body: sopDataAsync.when(
        data: (sopData) {
          if (sopData == null || sopData.steps.isEmpty) {
            return Center(child: Text(l10n.noSopData));
          }
          final steps = sopData.steps;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              return _buildStepCard(context, ref, step, index + 1);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(l10n.errorLoadingSop(err.toString()))),
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, WidgetRef ref, dynamic step, int stepNumber) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.stepLabel(stepNumber.toString()), style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(step.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    step.description,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      ref.read(selectedSopStepProvider.notifier).setStep(step);
                      context.push('/sop/step-detail');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      side: const BorderSide(color: AppColors.primaryGreen),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(100, 36),
                    ),
                    child: Text(l10n.readMore),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
