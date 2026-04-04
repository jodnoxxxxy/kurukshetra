import 'package:flutter/material.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import '../models/soil_model.dart';

class SoilStatusCard extends StatelessWidget {
  final String label;
  final SoilCategory category;

  const SoilStatusCard({super.key, required this.label, required this.category});

  @override
  Widget build(BuildContext context) {
    Color mainColor;
    IconData icon;

    final status = category.status.toLowerCase();

    if (status == 'low' || status == 'acidic' || status == 'alkaline') {
      mainColor = Colors.redAccent;
      icon = Icons.warning_amber_rounded;
    } else if (status == 'medium') {
      mainColor = Colors.orange;
      icon = Icons.info_outline_rounded;
    } else {
      mainColor = Colors.green;
      icon = Icons.check_circle_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: mainColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: mainColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black87)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: mainColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              L10nUtils.translateSoilStatus(context, category.status).toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.w900, color: mainColor, fontSize: 10, letterSpacing: 0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(category.message, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            child: LinearProgressIndicator(
              value: _getValue(status),
              backgroundColor: mainColor.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(mainColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  double _getValue(String status) {
    if (status == 'low' || status == 'acidic') return 0.3;
    if (status == 'medium') return 0.6;
    return 1.0;
  }
}

class SoilHealthScoreGauge extends StatelessWidget {
  final int score;

  const SoilHealthScoreGauge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color color = score >= 70 ? Colors.green : (score >= 40 ? Colors.orange : Colors.redAccent);
    String label = score >= 70 ? 'HEALTHY' : (score >= 40 ? 'MODERATE' : 'POOR');

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.05), Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160, height: 160,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 14,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text('$score%', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: color, height: 1)),
                  Text(
                    L10nUtils.translateSoilHealthLabel(context, label),
                    style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.7), fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(l10n.soilHealthScore.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1.5)),
        ],
      ),
    );
  }
}
