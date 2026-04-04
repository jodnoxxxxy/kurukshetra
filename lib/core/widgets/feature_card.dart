import 'package:flutter/material.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color baseColor;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.icon,
    required this.baseColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: baseColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: baseColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Icon(icon, color: baseColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyles.bodyBold.copyWith(
              fontSize: 12,
              height: 1.1,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
