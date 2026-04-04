import 'package:flutter/material.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback? onTrailingTap;
  final String? trailingLabel;
  final Color? color;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.onTrailingTap,
    this.trailingLabel,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: color ?? const Color(0xFF138808)),
            const SizedBox(width: 8),
          ],
          Text(
            title.toUpperCase(),
            style: AppTextStyles.labelCaps.copyWith(color: color),
          ),
          if (onTrailingTap != null) ...[
            const Spacer(),
            TextButton(
              onPressed: onTrailingTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 20),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                trailingLabel ?? 'VIEW ALL',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF138808),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
