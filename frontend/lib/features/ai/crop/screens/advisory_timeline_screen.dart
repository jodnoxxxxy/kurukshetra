import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/core/widgets/app_card.dart';
import 'package:kurukshetra/core/widgets/section_header.dart';
import 'package:kurukshetra/core/widgets/status_badge.dart';
import 'package:kurukshetra/features/home/models/weather.dart';
import 'package:kurukshetra/features/home/providers/weather_provider.dart';
import '../providers/advisory_provider.dart';
import '../models/crop_advisory.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class AdvisoryTimelineScreen extends ConsumerWidget {
  const AdvisoryTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final crop = ref.watch(selectedCropProvider);
    final stagesAsync = ref.watch(cropStagesProvider);
    final weatherAsync = ref.watch(weatherProvider);
    final currentDay = ref.watch(currentStageDayProvider);
    final sowingDate = ref.watch(selectedSowingDateProvider);

    if (crop == null || sowingDate == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.advisoryTimeline)),
        body: Center(child: Text(l10n.selectCropSowingDateFirst)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, crop, l10n),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProgressBanner(context, currentDay, sowingDate, l10n),
                  const SizedBox(height: 24),
                  _buildAITaskSpotlight(context, l10n),
                  const SizedBox(height: 32),
                  _buildEnvironmentMonitoring(context, weatherAsync, l10n),
                  const SizedBox(height: 40),
                  SectionHeader(title: 'Growth Timeline', icon: Icons.timeline_rounded),
                  const SizedBox(height: 16),
                  stagesAsync.when(
                    data: (stages) => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: stages.length,
                      itemBuilder: (context, i) {
                        final stage = stages[i];
                        return _buildAdvancedStageItem(context, stage, currentDay, l10n);
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
                    error: (e, _) => Center(child: Text('Failed to load stages: $e')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryGreen,
        onPressed: () => context.push('/messaging'),
        label: const Text('Ask AI Expert', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        icon: const Icon(Icons.forum_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, CropInfo crop, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      elevation: 0,
       backgroundColor: AppColors.primaryGreen,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 64, bottom: 64),
        title: Text(
          L10nUtils.translateCrop(context, crop.name.toLowerCase()),
          style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 22),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(crop.imageUrl, fit: BoxFit.cover),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent, AppColors.primaryGreen],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBanner(BuildContext context, int currentDay, DateTime sowingDate, AppLocalizations l10n) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryGreen,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Progress', style: AppTextStyles.labelCaps.copyWith(color: Colors.white70, fontSize: 10)),
              const SizedBox(height: 4),
              Text('Day $currentDay', style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const Icon(Icons.event_rounded, color: Colors.white, size: 16),
                const SizedBox(height: 4),
                Text('${sowingDate.day}/${sowingDate.month}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAITaskSpotlight(BuildContext context, AppLocalizations l10n) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.1), width: 2),
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
                  Text('AI Daily Insight', style: AppTextStyles.h3.copyWith(color: AppColors.primaryGreen)),
                ],
              ),
              StatusBadge(label: 'HIGH PRIORITY', statusType: StatusType.warning),
            ],
          ),
          const SizedBox(height: 16),
          Text('Irrigation Required Tomorrow', style: AppTextStyles.bodyBold.copyWith(fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            'Soil moisture level dropping below 45% in your region. Prepare for light irrigation (2L/m²).',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentMonitoring(BuildContext context, AsyncValue<WeatherInfo> weather, AppLocalizations l10n) {
    return weather.when(
      data: (w) => Row(
        children: [
          Expanded(child: _miniMonitoringCard(Icons.thermostat_rounded, '${w.temperature}°C', 'Temp', Colors.orange)),
          const SizedBox(width: 16),
          Expanded(child: _miniMonitoringCard(Icons.water_drop_rounded, '65%', 'Humidity', Colors.blue)),
          const SizedBox(width: 16),
          Expanded(child: _miniMonitoringCard(Icons.wb_sunny_rounded, w.condition, 'Sky', Colors.amber)),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }

  Widget _miniMonitoringCard(IconData icon, String value, String label, Color color) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.bodyBold.copyWith(fontSize: 14)),
          Text(label, style: AppTextStyles.labelCaps.copyWith(fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildAdvancedStageItem(BuildContext context, CropStage stage, int currentDay, AppLocalizations l10n) {
    final isCompleted = currentDay > stage.endDay;
    final isCurrent = currentDay >= stage.startDay && currentDay <= stage.endDay;
    final statusColor = isCompleted ? AppColors.primaryGreen : (isCurrent ? Colors.orange : Colors.grey.shade300);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCurrent ? Colors.white : statusColor,
                  shape: BoxShape.circle,
                  border: isCurrent ? Border.all(color: Colors.orange, width: 4) : null,
                  boxShadow: isCurrent ? [BoxShadow(color: Colors.orange.withValues(alpha: 0.3), blurRadius: 10)] : [],
                ),
                child: isCompleted ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: statusColor.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(stage.title, style: AppTextStyles.h3.copyWith(color: isCurrent || isCompleted ? Colors.black87 : Colors.grey.shade500)),
                      Text('${stage.startDay}-${stage.endDay} Days', style: AppTextStyles.badgeText.copyWith(color: Colors.grey.shade400)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (stage.advisories.isNotEmpty)
                    ...stage.advisories.map((a) => _buildAdvisoryTile(context, a, isCurrent, l10n)).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvisoryTile(BuildContext context, AdvisoryDetail advisory, bool isCurrent, AppLocalizations l10n) {
    IconData icon;
    Color color;

    switch (advisory.type.toLowerCase()) {
      case 'pest': icon = Icons.bug_report_rounded; color = Colors.red; break;
      case 'disease': icon = Icons.coronavirus_rounded; color = Colors.orange; break;
      case 'fertilizer': icon = Icons.science_rounded; color = Colors.teal; break;
      case 'irrigation': icon = Icons.water_drop_rounded; color = Colors.blue; break;
      default: icon = Icons.info_rounded; color = Colors.grey; break;
    }

    return AppCard(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () => _showAdvisoryDetails(context, advisory, l10n),
      color: isCurrent ? Colors.white : Colors.grey.shade50,
      border: isCurrent ? Border.all(color: color.withValues(alpha: 0.1)) : null,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(advisory.title, style: AppTextStyles.bodyBold.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(advisory.shortDescription, style: AppTextStyles.bodySmall.copyWith(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  void _showAdvisoryDetails(BuildContext context, AdvisoryDetail advisory, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 32),
            Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: AppColors.primaryGreen, size: 28),
                const SizedBox(width: 16),
                Expanded(child: Text(advisory.title, style: AppTextStyles.h1.copyWith(fontSize: 22))),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _sourceChip(Icons.auto_awesome_rounded, 'AI Engine', Colors.purple),
                _sourceChip(Icons.psychology_rounded, 'Experts', Colors.blue),
                _sourceChip(Icons.menu_book_rounded, 'KVK Papers', Colors.orange),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detailed Guidance',
                      style: AppTextStyles.labelCaps.copyWith(color: Colors.grey, fontSize: 10),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      advisory.detailedContent,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 15, height: 1.6, color: Colors.grey.shade800),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline_rounded, color: Colors.blue, size: 16),
                              SizedBox(width: 8),
                              Text('Why trust this advice?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This recommendation is cross-verified by Kurukshetra AI using ICAR research papers and local Krishi Vigyan Kendra (KVK) guidelines.',
                            style: TextStyle(fontSize: 12, color: Colors.blue.shade900, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Confirmed', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sourceChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
