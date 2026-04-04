import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/core/widgets/app_card.dart';
import 'package:kurukshetra/core/widgets/section_header.dart';
import 'package:kurukshetra/core/widgets/status_badge.dart';
import 'package:kurukshetra/core/widgets/list_tile_card.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';
import '../providers/dashboard_provider.dart';
import 'package:kurukshetra/features/home/providers/crop_provider.dart';
import 'package:kurukshetra/features/ai/soil/screens/soil_analysis_screen.dart';
import 'package:kurukshetra/features/ai/pest/screens/pest_detection_screen.dart';
import 'package:kurukshetra/features/home/screens/add_crop_screen.dart';

class FarmerDashboardScreen extends ConsumerStatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  ConsumerState<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends ConsumerState<FarmerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(context, state, l10n),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 _buildStatsRow(context, state, l10n),
                const SizedBox(height: 32),
                SectionHeader(
                  title: 'My Crops', 
                  icon: Icons.agriculture_rounded,
                  onTrailingTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCropScreen()));
                  },
                  trailingLabel: 'ADD',
                ),
                _buildMyCrops(context, state.activeCrops, l10n),
                const SizedBox(height: 32),
                SectionHeader(
                  title: 'Crop Health', 
                  icon: Icons.health_and_safety_rounded,
                  onTrailingTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PestDetectionScreen()));
                  },
                  trailingLabel: 'VIEW ALL',
                ),
                _buildCropHealth(context, state.cropHealthOverview),
                const SizedBox(height: 32),
                SectionHeader(
                  title: 'Soil Health', 
                  icon: Icons.grass_rounded, 
                  onTrailingTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SoilAnalysisScreen()));
                  }, 
                  trailingLabel: 'VIEW FULL'
                ),
                _buildSoilHealth(context, state.soilHealth, l10n),
                const SizedBox(height: 32),
                SectionHeader(title: 'Market Snapshot', icon: Icons.trending_up_rounded),
                _buildMarketPrices(context, state.marketPrices, l10n),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, FarmerDashboardState state, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 240,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primaryGreen,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Colors.white),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      centerTitle: false,
      titleSpacing: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF138808)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50, top: -50,
                child: Container(width: 200, height: 200, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), shape: BoxShape.circle)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 6),
                        Text(state.location.toUpperCase(), style: AppTextStyles.labelCaps.copyWith(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Farm Overview', style: AppTextStyles.h1.copyWith(color: Colors.white)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _appBarStat(l10n.acres(state.farmAreaAcres.toString()), 'AREA'),
                        _appBarStat(state.currentSeason, 'SEASON'),
                        _appBarStat(state.totalCrops.toString(), 'MY CROPS'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _appBarStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 18)),
        Text(label, style: AppTextStyles.labelCaps.copyWith(color: Colors.white.withValues(alpha: 0.6), fontSize: 9)),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, FarmerDashboardState state, AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // Organic Score
          _buildCompactStat(
            icon: Icons.eco_rounded,
            color: Colors.green,
            value: '${state.organicScore.toInt()}%',
            label: 'Organic Score',
          ),
          const SizedBox(width: 12),
          // Total Investment
          _buildCompactStat(
            icon: Icons.account_balance_wallet_rounded,
            color: Colors.orange,
            value: '₹${(state.totalInvestment / 1000).toStringAsFixed(1)}k',
            label: 'Investment',
          ),
          const SizedBox(width: 12),
          // Est. Profit
          _buildCompactStat(
            icon: Icons.trending_up_rounded,
            color: Colors.blue,
            value: '₹${(state.expectedProfit / 1000).toStringAsFixed(1)}k',
            label: 'Est. Profit',
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStat({required IconData icon, required Color color, required String value, required String label}) {
    return AppCard(
      width: 140,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.h2.copyWith(color: color, fontSize: 18)),
          Text(label, style: AppTextStyles.labelCaps.copyWith(fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildMyCrops(BuildContext context, List<Map<String, dynamic>> crops, AppLocalizations l10n) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: crops.length,
        itemBuilder: (ctx, i) {
          final c = crops[i];
          return Stack(
            children: [
              AppCard(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(c['icon'], style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(L10nUtils.translateCrop(context, c['name']), style: AppTextStyles.bodyBold, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Stage: ${c['stage']}', style: AppTextStyles.bodySmall),
                    const SizedBox(height: 4),
                    StatusBadge(label: 'Day ${c['days']}', statusType: StatusType.success),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                top: 4,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: Colors.red),
                  onPressed: () {
                    // We need to find the real ID from the backend listing if possible,
                    // but for Dashboard state we'll assume it exists in myCropProvider.
                    // If we don't have id in dashboard state, we'll need to add it.
                    if (c['id'] != null) {
                      ref.read(myCropProvider.notifier).deleteCrop(c['id']);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removing crop...')));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCropHealth(BuildContext context, List<Map<String, dynamic>> healthData) {
    return Column(
      children: healthData.map((data) {
        final isRisk = data['riskLevel'] != 'Low';
        final statusType = isRisk ? (data['riskLevel'] == 'High' ? StatusType.danger : StatusType.warning) : StatusType.success;
        
        return ListTileCard(
          icon: isRisk ? Icons.warning_rounded : Icons.verified_rounded,
          iconColor: isRisk ? (statusType == StatusType.danger ? Colors.red : Colors.orange) : Colors.green,
          title: L10nUtils.translateCrop(context, data['name']),
          subtitle: data['alert'] != null ? data['alert'] : 'Condition stable',
          trailing: StatusBadge(label: data['status'], statusType: statusType),
        );
      }).toList(),
    );
  }

  Widget _buildSoilHealth(BuildContext context, Map<String, String> soilLevels, AppLocalizations l10n) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFF3E2723), // Deep brown
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: soilLevels.entries.map((e) {
              final isLow = e.value.contains('Low');
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.key, style: AppTextStyles.labelCaps.copyWith(color: Colors.white54, fontSize: 9)),
                    const SizedBox(height: 2),
                    Text(
                      L10nUtils.translateSoilStatus(context, e.value),
                      style: AppTextStyles.bodyBold.copyWith(color: isLow ? Colors.orangeAccent : Colors.white),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketPrices(BuildContext context, List<Map<String, dynamic>> prices, AppLocalizations l10n) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: prices.length,
        separatorBuilder: (context, _) => Divider(indent: 20, endIndent: 20, color: Colors.grey.withValues(alpha: 0.1)),
        itemBuilder: (context, index) {
          final item = prices[index];
          final isUp = item['trend'] == 'up';
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            title: Text(L10nUtils.translateCrop(context, item['crop']), style: AppTextStyles.bodyBold),
            subtitle: Text('per ${item['unit']}', style: AppTextStyles.bodySmall),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(item['price'], style: AppTextStyles.h3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded, size: 14, color: isUp ? Colors.green : Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      isUp ? 'Rising' : 'Falling', 
                      style: AppTextStyles.badgeText.copyWith(color: isUp ? Colors.green : Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
