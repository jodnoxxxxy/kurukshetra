import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/profile/screens/faq_screen.dart';
import 'package:kurukshetra/features/profile/screens/report_issue_screen.dart';
import 'package:kurukshetra/features/profile/screens/user_guide_screen.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryGreen, Colors.green.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get support for your farming needs',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Help Options
            const Text(
              'Quick Help',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickHelpCard(
                    context,
                    '📞 Call Expert',
                    'Talk to agriculture expert',
                    Colors.blue,
                    () => _callExpert(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickHelpCard(
                    context,
                    '💬 Chat Support',
                    'AI assistant available 24/7',
                    AppColors.primaryGreen,
                    () => _openChat(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickHelpCard(
                    context,
                    '❓ FAQs',
                    'Find quick answers',
                    Colors.orange,
                    () => _openFAQs(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickHelpCard(
                    context,
                    '📚 User Guide',
                    'Learn app features',
                    Colors.purple,
                    () => _openUserGuide(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Support Categories
            const Text(
              'Support Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSupportCategory(
              '🌾 Crop Management',
              'Help with adding, editing, and managing crops',
              ['Add new crops', 'Edit crop details', 'Delete crops', 'Crop health monitoring'],
              () => _openCropSupport(context),
            ),
            const SizedBox(height: 12),
            _buildSupportCategory(
              '🌤️ Weather & Climate',
              'Weather forecasts and climate information',
              ['Understanding weather data', 'Weather alerts', 'Climate adaptation'],
              () => _openWeatherSupport(context),
            ),
            const SizedBox(height: 12),
            _buildSupportCategory(
              '💰 Market & Sales',
              'Market prices and selling your produce',
              ['Market price updates', 'Finding buyers', 'Payment processing'],
              () => _openMarketSupport(context),
            ),
            const SizedBox(height: 12),
            _buildSupportCategory(
              '🏛️ Government Schemes',
              'Government programs and subsidies',
              ['PM-KISAN', 'Crop insurance', 'Subsidy applications'],
              () => _openSchemeSupport(context),
            ),
            const SizedBox(height: 12),
            _buildSupportCategory(
              '🔧 Technical Issues',
              'App problems and technical support',
              ['Login issues', 'App crashes', 'Data synchronization'],
              () => _openTechnicalSupport(context),
            ),
            const SizedBox(height: 24),

            // Contact Information
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildContactItem(
                      '📞 Helpline',
                      '1800-123-4567',
                      'Available 24/7 for emergencies',
                    ),
                    const Divider(),
                    _buildContactItem(
                      '📧 Email Support',
                      'support@kurukshetra.com',
                      'We respond within 24 hours',
                    ),
                    const Divider(),
                    _buildContactItem(
                      '📍 Office Address',
                      'Khed, Maharashtra 410201',
                      'Visit us for in-person support',
                    ),
                    const Divider(),
                    _buildContactItem(
                      '⏰ Working Hours',
                      'Mon-Sat: 9:00 AM - 6:00 PM',
                      'Emergency support available 24/7',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Report Issue Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _reportIssue(context),
                icon: const Icon(Icons.bug_report),
                label: const Text('Report an Issue'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHelpCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              title.split(' ')[0],
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              title.split(' ').sublist(1).join(' '),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCategory(
    String title,
    String description,
    List<String> topics,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: topics.map((topic) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      topic,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(String title, String value, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
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
            SizedBox(height: 8),
            Text('Specialization: Crop management, Soil health, Pest control'),
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

  void _openChat(BuildContext context) {
    Navigator.of(context).pushNamed('/chat');
  }

  void _openFAQs(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FAQScreen(),
      ),
    );
  }

  void _openUserGuide(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UserGuideScreen(),
      ),
    );
  }

  void _openCropSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening crop management support...')),
    );
  }

  void _openWeatherSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening weather support...')),
    );
  }

  void _openMarketSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening market support...')),
    );
  }

  void _openSchemeSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening scheme support...')),
    );
  }

  void _openTechnicalSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening technical support...')),
    );
  }

  void _reportIssue(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ReportIssueScreen(),
      ),
    );
  }
}
