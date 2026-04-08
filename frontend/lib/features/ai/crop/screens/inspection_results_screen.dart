import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/core/widgets/app_card.dart';
import 'package:kurukshetra/core/widgets/primary_button.dart';
import 'package:kurukshetra/core/widgets/section_header.dart';
import 'package:kurukshetra/core/widgets/status_badge.dart';
import 'package:kurukshetra/features/ai/crop/models/crop_inspection.dart';
import 'package:kurukshetra/features/ai/crop/providers/crop_inspection_provider.dart';

class InspectionResultsScreen extends ConsumerWidget {
  const InspectionResultsScreen({
    super.key,
    required this.fieldId,
  });

  final String fieldId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspectionsAsync = ref.watch(fieldInspectionsProvider(fieldId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection History'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: inspectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load inspections: $e')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No manual checks found', style: AppTextStyles.h3),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      text: 'Create Manual Check',
                      onPressed: () => context.push('/crops/manual-check?fieldId=$fieldId'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _InspectionTile(inspection: items[index]),
          );
        },
      ),
    );
  }
}

class _InspectionTile extends StatelessWidget {
  const _InspectionTile({required this.inspection});

  final CropInspection inspection;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(inspection.getHealthStatusLabel(), style: AppTextStyles.h3),
              ),
              StatusBadge(
                label: inspection.getRiskLevelLabel(),
                statusType: _statusType(inspection.riskLevel),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const SectionHeader(title: 'Details', icon: Icons.list_alt),
          if ((inspection.pests ?? '').isNotEmpty)
            Text('Pests: ${inspection.pests}', style: AppTextStyles.bodyMedium),
          if ((inspection.diseases ?? '').isNotEmpty)
            Text('Diseases: ${inspection.diseases}', style: AppTextStyles.bodyMedium),
          if ((inspection.issues ?? '').isNotEmpty)
            Text('Issues: ${inspection.issues}', style: AppTextStyles.bodyMedium),
          if ((inspection.recommendation ?? '').isNotEmpty)
            Text('Recommendation: ${inspection.recommendation}', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          Text(inspection.getFormattedInspectionDate(), style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  StatusType _statusType(String? risk) {
    switch (risk) {
      case 'LOW':
        return StatusType.success;
      case 'MEDIUM':
        return StatusType.warning;
      case 'HIGH':
      case 'CRITICAL':
        return StatusType.error;
      default:
        return StatusType.neutral;
    }
  }
}
