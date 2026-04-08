import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';

class OrganicCertificationScreen extends ConsumerWidget {
  const OrganicCertificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    if (profileState.profile == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9FBF9),
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
      );
    }

    final profile = profileState.profile!;
    final score = profile.organicScore;
    final status = profile.organicStatus;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            title: const Text(
              'Organic Excellence',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            backgroundColor: const Color(0xFFF9FBF9),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainStatusCard(score, status),
                  const SizedBox(height: 32),
                  _buildSectionHeader('QUALITY BREAKDOWN', Icons.insights_rounded),
                  _buildScoreBreakdown(score),
                  const SizedBox(height: 32),
                  _buildSectionHeader('ROADMAP TO 100%', Icons.analytics_outlined),
                  _buildRequirementsSection(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('CERTIFICATION TIMELINE', Icons.timer_outlined),
                  _buildTimelineSection(),
                  const SizedBox(height: 40),
                  _buildActionButtons(context),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStatusCard(double score, String status) {
    final isCertified = status.toLowerCase().contains('certified');
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCertified 
              ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
              : [const Color(0xFFE65100), const Color(0xFFEF6C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: (isCertified ? Colors.green : Colors.orange).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                  ),
                  Text(
                    status.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(16)),
                child: Icon(isCertified ? Icons.verified_rounded : Icons.eco_rounded, color: Colors.white, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text(
                    '${score.toInt()}',
                    style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1),
                  ),
                  Text(
                    'ORGANIC SCORE',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          if (!isCertified) ...[
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(16)),
              child: Text(
                'Gain ${100 - score.toInt()}% more to reach official Certification',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreBreakdown(double score) {
    final categories = [
      {'name': 'Soil Health', 'score': 85.0, 'icon': Icons.grass_rounded, 'color': Colors.green},
      {'name': 'Water Purity', 'score': 78.0, 'icon': Icons.water_drop_rounded, 'color': Colors.blue},
      {'name': 'Biodiversity', 'score': 82.0, 'icon': Icons.pets_rounded, 'color': Colors.orange},
      {'name': 'Eco-Friendly', 'score': 90.0, 'icon': Icons.auto_awesome_rounded, 'color': Colors.teal},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: categories.map((c) {
          final s = c['score'] as double;
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: (c['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(c['icon'] as IconData, color: c['color'] as Color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('${s.toInt()}%', style: TextStyle(fontWeight: FontWeight.w900, color: c['color'] as Color)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: s / 100,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(c['color'] as Color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRequirementsSection() {
    final requirements = [
      {'title': 'Chemical-Free Soil', 'done': true},
      {'title': 'Natural Pest Control', 'done': true},
      {'title': 'Monthly Quality Audits', 'done': false},
      {'title': 'Detailed Record Keeping', 'done': false},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: requirements.map((r) {
          final done = r['done'] as bool;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: done ? AppColors.primaryGreen : Colors.grey.shade300, size: 22),
                const SizedBox(width: 12),
                Text(
                  r['title'] as String,
                  style: TextStyle(fontSize: 14, fontWeight: done ? FontWeight.bold : FontWeight.w500, color: done ? Colors.black87 : Colors.black45),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimelineSection() {
    final steps = [
      {'label': 'Application Sent', 'done': true},
      {'label': 'Document Review', 'done': true},
      {'label': 'On-Site Inspection', 'done': false},
      {'label': 'Final Approval', 'done': false},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: List.generate(steps.length, (i) {
          final s = steps[i];
          final done = s['done'] as bool;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(color: done ? AppColors.primaryGreen : Colors.grey.shade200, shape: BoxShape.circle),
                  ),
                  if (i < steps.length - 1)
                    Container(width: 2, height: 30, color: done ? AppColors.primaryGreen.withValues(alpha: 0.3) : Colors.grey.shade100),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    s['label'] as String,
                    style: TextStyle(fontSize: 13, fontWeight: done ? FontWeight.bold : FontWeight.w500, color: done ? Colors.black87 : Colors.grey),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _apply(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: AppColors.primaryGreen.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('ACCELERATE CERTIFICATION', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryGreen, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('VIEW STANDARDS', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
        ),
      ],
    );
  }

  void _apply(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Official Application', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('An expert from Kurukshetra will be assigned to your farm to conduct a preliminary assessment.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CLOSE')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('CONFIRM'),
          ),
        ],
      ),
    );
  }
}
