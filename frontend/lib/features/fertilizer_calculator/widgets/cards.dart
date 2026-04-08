import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../models/soil_model.dart';
import '../models/fertilizer_model.dart';

import 'package:kurukshetra/l10n/app_localizations.dart';

class NutrientCard extends StatelessWidget {
  final String label;
  final NutrientLevel level;

  const NutrientCard({super.key, required this.label, required this.level});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color cardColor;
    String statusText;
    IconData icon;

    switch (level) {
      case NutrientLevel.low:
        cardColor = Colors.red.shade50;
        statusText = l10n.low;
        icon = Icons.arrow_downward;
        break;
      case NutrientLevel.medium:
        cardColor = Colors.orange.shade50;
        statusText = l10n.medium;
        icon = Icons.horizontal_rule;
        break;
      case NutrientLevel.high:
        cardColor = Colors.green.shade50;
        statusText = l10n.high;
        icon = Icons.arrow_upward;
        break;
    }

    Color foregroundColor = level == NutrientLevel.low ? Colors.red.shade700 : (level == NutrientLevel.medium ? Colors.orange.shade800 : Colors.green.shade800);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: foregroundColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Icon(icon, color: foregroundColor),
            const SizedBox(height: 8),
            Text(
              statusText,
              style: TextStyle(color: foregroundColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class FertilizerCard extends StatelessWidget {
  final FertilizerRecommendation rec;

  const FertilizerCard({super.key, required this.rec});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Color badgeColor = rec.isOrganic ? AppColors.primaryGreen : Colors.blueGrey;
    final IconData icon = rec.isOrganic ? Icons.eco : Icons.science;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: badgeColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(rec.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Text(rec.targetNutrient, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(rec.description, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      l10n.applicationRate(rec.amount.toString(), rec.unit),
                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
