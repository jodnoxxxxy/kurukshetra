import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import '../providers/pest_provider.dart';

class DetectionResultScreen extends ConsumerWidget {
  const DetectionResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(currentDetectionProvider);
    final l10n = AppLocalizations.of(context)!;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.error)),
        body: Center(child: Text(l10n.noAnalysisFound)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(l10n.aiAnalysisComplete, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(currentDetectionProvider.notifier).clear();
              context.pop();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: kIsWeb
                  ? Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Image display not available on web platform'),
                        ),
                      ),
                    )
                  : Image.file(
                      File(result.imagePath),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(height: 250, color: Colors.grey.shade300, child: const Center(child: Icon(Icons.error_outline))),
                    ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    l10n.detectedLabel(L10nUtils.translatePest(context, result.pest.name)),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.confidenceLabel((result.confidenceScore * 100).toStringAsFixed(1)), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    l10n.affectingLabel(
                      result.affectedCrop.contains('Unknown') 
                      ? l10n.unknownCrop 
                      : L10nUtils.translateCropName(context, result.affectedCrop)
                    ), 
                    style: TextStyle(color: Colors.grey.shade600)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(selectedPestProvider.notifier).setPest(result.pest);
                  context.push('/pest-detection/info');
                },
                icon: const Icon(Icons.eco),
                label: Text(l10n.viewOrganicSolutions),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
