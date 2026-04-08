import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../providers/sop_provider.dart';

import 'package:kurukshetra/l10n/app_localizations.dart';

class SopDetailScreen extends ConsumerWidget {
  const SopDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final step = ref.watch(selectedSopStepProvider);

    if (step == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.sopDetail)),
        body: Center(child: Text(l10n.stepDetailsNotFound)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(step.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (step.imageUrl.isNotEmpty)
              Image.network(
                step.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    step.detailedContent,
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  if (step.tips.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb, color: Colors.amber),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.proTip, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade800)),
                                const SizedBox(height: 4),
                                Text(
                                  step.tips,
                                  style: TextStyle(color: Colors.amber.shade900, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Future implementation for Text-to-Speech
                      },
                      icon: const Icon(Icons.volume_up),
                      label: Text(l10n.listenToInstructions),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
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
