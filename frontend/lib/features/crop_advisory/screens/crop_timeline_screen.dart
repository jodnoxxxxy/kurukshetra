import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/growth_step.dart';
import '../providers/crop_advisory_provider.dart';

class CropTimelineScreen extends ConsumerWidget {
  const CropTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cropAdvisoryProvider);
    final crop = state.selectedCrop;

    if (crop == null) {
      return const Scaffold(body: Center(child: Text('No crop selected')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                crop.name,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [const Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              background: Image.network(
                crop.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.green),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAdvisorySection(context),
                  const SizedBox(height: 32),
                  Text(
                    'Growth Timeline',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step-by-step farming process',
                    style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final step = crop.steps[index];
                return _buildTimelineStep(step, index, index == crop.steps.length - 1);
              },
              childCount: crop.steps.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvisorySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tips_and_updates, color: Colors.green),
              const SizedBox(width: 12),
              Text(
                'AI Advisory',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Based on current weather, we recommend starting sowing within the next 3 days for optimal yield.',
            style: GoogleFonts.outfit(fontSize: 15, color: Colors.green[900]),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person, size: 18),
            label: const Text('Contact Expert for Help'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green[800],
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(GrowthStep step, int index, bool isLast) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D5A27),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(step.icon, color: Colors.white, size: 20),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFFC8E6C9),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        step.title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${step.duration.inDays} Days',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.description,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
