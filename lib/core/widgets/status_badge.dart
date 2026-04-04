import 'package:flutter/material.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';

enum StatusType { success, warning, danger, info, error, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType statusType;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.statusType = StatusType.neutral,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    switch (statusType) {
      case StatusType.success:
        baseColor = const Color(0xFF1B5E20);
        break;
      case StatusType.warning:
        baseColor = const Color(0xFFE65100);
        break;
      case StatusType.danger:
      case StatusType.error:
        baseColor = const Color(0xFFB71C1C);
        break;
      case StatusType.info:
        baseColor = const Color(0xFF01579B);
        break;
      case StatusType.neutral:
        baseColor = const Color(0xFF455A64);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.08), 
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: baseColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: baseColor),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: AppTextStyles.badgeText.copyWith(color: baseColor),
          ),
        ],
      ),
    );
  }
}
