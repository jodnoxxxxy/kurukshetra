import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../providers/climate_provider.dart';

class ClimateDetailScreen extends ConsumerWidget {
  const ClimateDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advisory = ref.watch(selectedClimateAdvisoryProvider);

    if (advisory == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail')),
        body: const Center(child: Text('No details found.')),
      );
    }

    // Determine illustration based on icon string
    String imagePath = 'https://images.unsplash.com/photo-1592424001815-1888ba37ec9b?auto=format&fit=crop&q=80&w=600';
    if (advisory.iconName == 'water_drop') {
      imagePath = 'https://images.unsplash.com/photo-1560493676-04071c5f467b?auto=format&fit=crop&q=80&w=600';
    } else if (advisory.iconName == 'wb_sunny') {
      imagePath = 'https://images.unsplash.com/photo-1558450143-6d00af4bbc9e?auto=format&fit=crop&q=80&w=600';
    } else if (advisory.iconName == 'grass') {
      imagePath = 'https://images.unsplash.com/photo-1574323347407-293e17ce4f52?auto=format&fit=crop&q=80&w=600';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(advisory.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              imagePath,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 220, color: Colors.grey.shade200),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(advisory.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(
                    advisory.detailedExplanation,
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.eco, color: AppColors.primaryGreen),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Organic Farming Tip', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                              const SizedBox(height: 4),
                              Text(
                                advisory.organicTips,
                                style: const TextStyle(color: Colors.black87, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
