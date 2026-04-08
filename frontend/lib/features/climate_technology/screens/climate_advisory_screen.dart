import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../providers/climate_provider.dart';
import '../models/climate_model.dart';

class ClimateAdvisoryScreen extends ConsumerWidget {
  const ClimateAdvisoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advisoriesAsync = ref.watch(climateAdvisoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Climate Advisories'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: advisoriesAsync.when(
        data: (advisories) {
          if (advisories.isEmpty) {
            return const Center(child: Text('No active advisories for current logic.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: advisories.length,
            itemBuilder: (context, index) {
              return _buildAdvisoryCard(context, ref, advisories[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Failed to load advisories: $err')),
      ),
    );
  }

  Widget _buildAdvisoryCard(BuildContext context, WidgetRef ref, ClimateAdvisory advisory) {
    IconData iconData = Icons.grass;
    switch (advisory.iconName) {
      case 'water_drop':
        iconData = Icons.water_drop;
        break;
      case 'wb_sunny':
        iconData = Icons.wb_sunny;
        break;
      case 'layers':
        iconData = Icons.layers;
        break;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: AppColors.primaryGreen, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(advisory.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(advisory.shortDescription, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(selectedClimateAdvisoryProvider.notifier).setAdvisory(advisory);
                        context.push('/climate-tech/advisory-detail');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Read More'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
