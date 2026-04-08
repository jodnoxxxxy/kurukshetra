import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Guide'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGuideSection('🚀 Getting Started', [
            _buildGuideItem(
              '1. Download & Install',
              'Download Kurukshetra from Google Play Store or App Store',
              Icons.download,
            ),
            _buildGuideItem(
              '2. Create Account',
              'Sign up with your mobile number and verify with OTP',
              Icons.person_add,
            ),
            _buildGuideItem(
              '3. Complete Profile',
              'Add your farm details and personal information',
              Icons.edit,
            ),
            _buildGuideItem(
              '4. Explore Dashboard',
              'Navigate through different features and get familiar',
              Icons.dashboard,
            ),
          ]),
          _buildGuideSection('🌾 Managing Crops', [
            _buildGuideItem(
              'Add Your First Crop',
              'Home → Add Crop → Select crop type → Enter details → Save',
              Icons.add_circle,
            ),
            _buildGuideItem(
              'Monitor Crop Health',
              'View crop status, growth progress, and health recommendations',
              Icons.monitor_heart,
            ),
            _buildGuideItem(
              'Edit Crop Information',
              'My Crops → Select crop → Edit → Update details',
              Icons.edit,
            ),
            _buildGuideItem(
              'Track Multiple Crops',
              'Manage different crops simultaneously with individual tracking',
              Icons.view_list,
            ),
          ]),
          _buildGuideSection('🌤️ Weather & Climate', [
            _buildGuideItem(
              'Check Daily Weather',
              'Home → Weather Card → View temperature, humidity, rainfall',
              Icons.cloud,
            ),
            _buildGuideItem(
              '7-Day Forecast',
              'Tap on weather card to see detailed weekly forecast',
              Icons.calendar_view_week,
            ),
            _buildGuideItem(
              'Weather Alerts',
              'Enable notifications for extreme weather warnings',
              Icons.notifications_active,
            ),
            _buildGuideItem(
              'Climate Adaptation',
              'Get recommendations based on weather patterns',
              Icons.eco,
            ),
          ]),
          _buildGuideSection('💰 Market & Sales', [
            _buildGuideItem(
              'Check Market Prices',
              'Home → Market Prices → View current rates and trends',
              Icons.trending_up,
            ),
            _buildGuideItem(
              'Sell Your Produce',
              'Sell Hub → List crops → Set price → Connect with buyers',
              Icons.store,
            ),
            _buildGuideItem(
              'Payment Processing',
              'Receive payments directly to your bank account',
              Icons.payment,
            ),
            _buildGuideItem(
              'Market Analysis',
              'View price trends and best time to sell',
              Icons.analytics,
            ),
          ]),
          _buildGuideSection('🐛 Pest & Disease', [
            _buildGuideItem(
              'Identify Issues',
              'Take photo of affected plant → AI detection → Get results',
              Icons.camera_alt,
            ),
            _buildGuideItem(
              'View Pest Alerts',
              'Check regional pest warnings and preventive measures',
              Icons.bug_report,
            ),
            _buildGuideItem(
              'Treatment Recommendations',
              'Get organic and chemical treatment options',
              Icons.healing,
            ),
            _buildGuideItem(
              'Preventive Measures',
              'Learn how to prevent common pest problems',
              Icons.security,
            ),
          ]),
          _buildGuideSection('📊 Reports & Analytics', [
            _buildGuideItem(
              'Farm Reports',
              'Profile → Farm Reports → Generate and download PDF reports',
              Icons.assessment,
            ),
            _buildGuideItem(
              'Profit & Loss',
              'Track income, expenses, and profitability',
              Icons.account_balance,
            ),
            _buildGuideItem(
              'Crop Performance',
              'Analyze yield trends and crop efficiency',
              Icons.insert_chart,
            ),
            _buildGuideItem(
              'Soil Health',
              'Monitor soil nutrients and improvement recommendations',
              Icons.grass,
            ),
          ]),
          _buildGuideSection('🔔 Notifications', [
            _buildGuideItem(
              'Enable Notifications',
              'Profile → Notifications → Choose alert types',
              Icons.notifications,
            ),
            _buildGuideItem(
              'Weather Alerts',
              'Get notified about weather changes',
              Icons.cloud_queue,
            ),
            _buildGuideItem(
              'Market Alerts',
              'Receive price change notifications',
              Icons.notifications_active,
            ),
            _buildGuideItem(
              'Pest Alerts',
              'Early warnings for pest risks',
              Icons.pest_control,
            ),
          ]),
          _buildGuideSection('💬 Support & Help', [
            _buildGuideItem(
              'AI Chat Assistant',
              'Floating chat button → Ask farming questions 24/7',
              Icons.chat,
            ),
            _buildGuideItem(
              'Call Expert',
              'Help & Support → Call Agriculture Expert',
              Icons.phone,
            ),
            _buildGuideItem(
              'FAQ Section',
              'Find answers to common questions',
              Icons.help,
            ),
            _buildGuideItem(
              'Report Issues',
              'Help & Support → Report Issue → Describe problem',
              Icons.bug_report,
            ),
          ]),
          const SizedBox(height: 24),
          
          // Tips Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💡 Pro Tips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 12),
                _buildTip('Update your crop information regularly for accurate recommendations'),
                _buildTip('Enable weather alerts to protect your crops from extreme conditions'),
                _buildTip('Check market prices before selling to get the best rates'),
                _buildTip('Use the AI chat assistant for quick farming advice'),
                _buildTip('Generate monthly reports to track your farm\'s progress'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildGuideItem(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 20),
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
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
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

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, color: AppColors.primaryGreen)),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
