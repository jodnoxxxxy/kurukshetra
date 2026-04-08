import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/crop_advisory_provider.dart';
import '../widgets/recommendation_card.dart';
import 'crop_timeline_screen.dart';

class CropRecommendationScreen extends ConsumerWidget {
  const CropRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cropAdvisoryProvider);
    final notifier = ref.read(cropAdvisoryProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      appBar: AppBar(
        title: Text(
          'Top Recommendations',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: state.recommendations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No recommendations found.',
                    style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.recommendations.length,
              itemBuilder: (context, index) {
                final crop = state.recommendations[index];
                return RecommendationCard(
                  crop: crop,
                  onTap: () {
                    notifier.selectCrop(crop);
                    context.push('/crop-advisory-new/timeline');
                  },
                );
              },
            ),
    );
  }
}
