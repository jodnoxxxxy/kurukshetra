import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';

class SupportAssistantSheet extends StatelessWidget {
  const SupportAssistantSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.face_retouching_natural_rounded, color: AppColors.primaryGreen, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Support Assistant', style: AppTextStyles.h2),
                    Text('How can we help you today?', style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade500)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSupportOption(
            context,
            icon: Icons.smart_toy_rounded,
            title: 'AI Chat Support',
            subtitle: 'Get instant answers from our AI assistant',
            color: Colors.green,
            onTap: () {
              Navigator.pop(context);
              context.push('/chat');
            },
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            context,
            icon: Icons.phone_rounded,
            title: 'Call Agriculture Expert',
            subtitle: 'Speak directly with an agriculture expert',
            color: Colors.blue,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            context,
            icon: Icons.help_center_rounded,
            title: 'FAQs',
            subtitle: 'Frequently asked questions and answers',
            color: Colors.orange,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            context,
            icon: Icons.bug_report_rounded,
            title: 'Report Issue',
            subtitle: 'Report a problem or suggest improvement',
            color: Colors.red,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyBold),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.badgeText.copyWith(color: Colors.grey.shade400, fontSize: 10)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
