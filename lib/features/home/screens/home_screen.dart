import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/core/widgets/app_card.dart';
import 'package:kurukshetra/core/widgets/feature_card.dart';
import 'package:kurukshetra/core/widgets/section_header.dart';
import 'package:kurukshetra/core/widgets/status_badge.dart';
import 'package:kurukshetra/core/widgets/language_selection_sheet.dart';
import 'package:kurukshetra/features/navigation/providers/navigation_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildTopBar(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreetingCard(),
                const SizedBox(height: 20),
                _buildDetailedWeatherCard(),
                const SizedBox(height: 24),
                _buildAIRecommendationSpotlight(),
                const SizedBox(height: 24),
                _buildPestDetectionCTA(),
                const SizedBox(height: 32),
                _buildCategorizedServices(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: false,
      elevation: 0,
      backgroundColor: const Color(0xFFF9FBF9),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF263238)),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          const Icon(Icons.agriculture_rounded, color: AppColors.primaryGreen, size: 28),
          const SizedBox(width: 10),
          Text('Kurukshetra', style: AppTextStyles.h2.copyWith(fontSize: 18)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.face_retouching_natural_rounded, color: Color(0xFF263238)), 
          onPressed: () => context.push('/profile/edit'),
        ),
        IconButton(
          icon: const Icon(Icons.language_rounded, color: Color(0xFF263238)), 
          onPressed: () => _showLanguageDialog(context, ref),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF263238)), 
          onPressed: () => context.push('/profile/notifications'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LanguageSelectionSheet(),
    );
  }

  Widget _buildGreetingCard() {
    final hour = DateTime.now().hour;
    String greeting = "Good Morning";
    IconData icon = Icons.wb_sunny_rounded;
    Color iconColor = Colors.orangeAccent;

    if (hour >= 12 && hour < 17) {
      greeting = "Good Afternoon";
      icon = Icons.wb_cloudy_rounded;
    } else if (hour >= 17 && hour < 21) {
      greeting = "Good Evening";
      icon = Icons.wb_twilight_rounded;
      iconColor = Colors.orange;
    } else if (hour >= 21 || hour < 5) {
      greeting = "Good Night";
      icon = Icons.nightlight_round;
      iconColor = Colors.yellowAccent;
    }

    return AppCard(
      color: AppColors.primaryGreen,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 48),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$greeting, Farmer', style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 22)),
                const SizedBox(height: 4),
                Text(
                  'Your farm is looking healthy today 🌾',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedWeatherCard() {
    return AppCard(
      padding: EdgeInsets.zero,
      color: Colors.blue.shade600,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd MMM yyyy | HH:mm').format(DateTime.now()),
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.location_on_rounded, color: Colors.white70, size: 16),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('28.5°C', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
                    const Text('Partly Cloudy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
                  ],
                ),
                const Icon(Icons.wb_sunny_rounded, color: Colors.yellowAccent, size: 80),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pune', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    const Icon(Icons.water_drop_rounded, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    const Text('65%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    const Icon(Icons.thermostat_rounded, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    const Text('16.7°C / 36.5°C', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIRecommendationSpotlight() {
    return AppCard(
      padding: const EdgeInsets.all(24),
      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.1), width: 2),
      color: const Color(0xFFF1F8E9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: AppColors.primaryGreen, size: 24),
                  const SizedBox(width: 10),
                  Text('AI Recommendation', style: AppTextStyles.h3.copyWith(color: AppColors.primaryGreen)),
                ],
              ),
              StatusBadge(label: '92% Match', statusType: StatusType.success),
            ],
          ),
          const SizedBox(height: 20),
          Text('Suggested Next Crop: Soybean', style: AppTextStyles.h2.copyWith(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Optimal soil pH and upcoming monsoon predicted for your coordinates.',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton(
              onPressed: () => context.push('/soil-analysis'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Analyze Full Farm Data',
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPestDetectionCTA() {
    return AppCard(
      color: const Color(0xFF2E7D32),
      padding: const EdgeInsets.all(20),
      onTap: () => context.push('/pest-detection'),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Identify Pest & Disease', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('1. Take Photo  ▶  2. Upload  ▶  3. Result', style: TextStyle(color: Colors.white70, fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorizedServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Primary', icon: Icons.star_rounded),
        _buildServiceGrid([
          {'icon': Icons.pest_control_rounded, 'title': 'Pest Detection', 'color': Colors.red.shade600, 'path': '/pest-detection'},
          {'icon': Icons.agriculture_rounded, 'title': 'Crop Advisory', 'color': Colors.green.shade600, 'path': '/crop-recommendation'},
          {'icon': Icons.thermostat_auto_rounded, 'title': 'Climate Tech', 'color': Colors.blue.shade600, 'path': '/climate-tech'},
        ]),
        const SizedBox(height: 32),
        SectionHeader(title: 'Tools', icon: Icons.construction_rounded),
        _buildServiceGrid([
          {'icon': Icons.calculate_rounded, 'title': 'Fertilizer Calculator', 'color': Colors.orange.shade600, 'path': '/fertilizer-calculator'},
          {'icon': Icons.analytics_rounded, 'title': 'Cost Calculator', 'color': Colors.purple.shade600, 'path': '/profile/analytics'},
          {'icon': Icons.layers_rounded, 'title': 'Soil Health Card', 'color': Colors.brown.shade600, 'path': '/soil-analysis'},
        ]),
        const SizedBox(height: 32),
        SectionHeader(title: 'Market', icon: Icons.trending_up_rounded),
        _buildServiceGrid([
          {'icon': Icons.shopping_basket_rounded, 'title': 'Market Prices', 'color': Colors.cyan.shade600, 'path': '/market-prices'},
          {'icon': Icons.account_balance_rounded, 'title': 'D.B.T.', 'color': Colors.indigo.shade600, 'path': '/dbt'},
          {'icon': Icons.warehouse_rounded, 'title': 'Warehouse', 'color': Colors.blueGrey.shade600, 'path': '/warehouse'},
        ]),
        const SizedBox(height: 32),
        SectionHeader(title: 'Knowledge', icon: Icons.menu_book_rounded),
        _buildServiceGrid([
          {'icon': Icons.assignment_rounded, 'title': 'S.O.P.', 'color': Colors.teal.shade700, 'path': '/sop'},
          {'icon': Icons.video_library_rounded, 'title': 'Shetishala', 'color': Colors.red.shade700, 'path': 'tab:2'},
          {'icon': Icons.forum_rounded, 'title': 'Talk to Experts', 'color': Colors.blue.shade700, 'path': '/messaging'},
        ]),
      ],
    );
  }

  Widget _buildServiceGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final s = items[index];
        return FeatureCard(
          title: s['title'] as String,
          icon: s['icon'] as IconData,
          baseColor: s['color'] as Color,
          onTap: () {
            final path = s['path'] as String;
            if (path.startsWith('tab:')) {
              final tabIndex = int.parse(path.split(':')[1]);
              ref.read(navigationProvider.notifier).setIndex(tabIndex);
            } else {
              context.push(path);
            }
          },
        );
      },
    );
  }
}
