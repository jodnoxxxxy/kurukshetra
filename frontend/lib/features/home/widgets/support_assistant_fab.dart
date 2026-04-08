import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class SupportAssistantFAB extends StatelessWidget {
  const SupportAssistantFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showSupportOptions(context),
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.support_agent),
    );
  }

  void _showSupportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.support_agent,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support Assistant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'How can we help you today?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Support Options
            _buildSupportOption(
              context,
              icon: Icons.chat,
              title: 'AI Chat Support',
              subtitle: 'Get instant help from our AI assistant',
              color: AppColors.primaryGreen,
              onTap: () {
                Navigator.of(context).pop();
                context.push('/chat');
              },
            ),
            const SizedBox(height: 12),
            _buildSupportOption(
              context,
              icon: Icons.phone,
              title: 'Call Agriculture Expert',
              subtitle: 'Talk to a farming expert directly',
              color: Colors.blue,
              onTap: () => _callExpert(context),
            ),
            const SizedBox(height: 12),
            _buildSupportOption(
              context,
              icon: Icons.help_outline,
              title: 'FAQs',
              subtitle: 'Find answers to common questions',
              color: Colors.orange,
              onTap: () => _openFAQs(context),
            ),
            const SizedBox(height: 12),
            _buildSupportOption(
              context,
              icon: Icons.menu_book,
              title: 'User Guide',
              subtitle: 'Learn how to use the app effectively',
              color: Colors.purple,
              onTap: () => _openUserGuide(context),
            ),
            const SizedBox(height: 12),
            _buildSupportOption(
              context,
              icon: Icons.bug_report,
              title: 'Report Issue',
              subtitle: 'Report a problem or suggest improvement',
              color: Colors.red,
              onTap: () => _reportIssue(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  void _callExpert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Agriculture Expert'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expert Available:'),
            SizedBox(height: 8),
            Text('📞 +91 98765 43210'),
            SizedBox(height: 8),
            Text('Available: 9:00 AM - 6:00 PM'),
            SizedBox(height: 8),
            Text('Language: English, Hindi, Marathi'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // In a real app, this would open the phone dialer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling expert...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _openFAQs(BuildContext context) {
    Navigator.of(context).pop();
    // Navigate to FAQs screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening FAQs...')),
    );
  }

  void _openUserGuide(BuildContext context) {
    Navigator.of(context).pop();
    // Navigate to User Guide screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening User Guide...')),
    );
  }

  void _reportIssue(BuildContext context) {
    Navigator.of(context).pop();
    // Navigate to Report Issue screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening Issue Report...')),
    );
  }
}
