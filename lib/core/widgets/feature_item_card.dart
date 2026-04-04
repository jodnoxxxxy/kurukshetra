import 'package:flutter/material.dart';
import 'package:kurukshetra/core/widgets/app_text.dart';

class FeatureItemCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color baseColor;
  final VoidCallback onTap;

  const FeatureItemCard({
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
                  color: baseColor.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
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
          AppText(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF455A64),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
