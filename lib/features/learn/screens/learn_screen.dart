import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/core/widgets/app_card.dart';
import 'package:kurukshetra/core/widgets/section_header.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/features/learn/providers/learn_provider.dart';
import 'package:kurukshetra/features/learn/screens/video_player_screen.dart';

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(l10n, context),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryFilter(l10n),
                const SizedBox(height: 32),
                SectionHeader(title: 'Featured Videos', icon: Icons.play_circle_fill_rounded),
                _buildVideoList(context, ref, l10n),
                const SizedBox(height: 40),
                 SectionHeader(title: 'Training Modules', icon: Icons.menu_book_rounded),
                _buildTrainingModules(l10n),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(AppLocalizations l10n, BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
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
        title: Text('Shetishala', style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 18)),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF138808)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Stack(
            children: [
              Positioned(right: -30, top: -20, child: Icon(Icons.school, size: 120, color: Colors.white.withValues(alpha: 0.05))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(AppLocalizations l10n) {
    final categories = ['All', 'Organic', 'Pest Control', 'Irrigation', 'Market Info'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (ctx, i) {
          final sel = i == _selectedCategoryIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(categories[i], style: AppTextStyles.bodyBold.copyWith(color: sel ? Colors.white : Colors.grey.shade600, fontSize: 12)),
              selected: sel,
              onSelected: (s) => setState(() => _selectedCategoryIndex = i),
              selectedColor: AppColors.primaryGreen,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: sel ? Colors.transparent : Colors.grey.shade200)),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final videosAsync = ref.watch(learnVideosProvider);
    return videosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (all) {
        final categories = ['All', 'Organic', 'Pest Control', 'Irrigation', 'Market Info'];
        final sel = categories[_selectedCategoryIndex];
        final filtered = sel == 'All' ? all : all.where((v) => v.category == sel || v.category == 'General').toList();
        
        if (filtered.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("No tutorials found.", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))));

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 20),
          itemBuilder: (ctx, i) {
            final v = filtered[i];
            return AppCard(
              padding: EdgeInsets.zero,
              onTap: () {
                if (v.videoUrl.isNotEmpty) Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerScreen(videoUrl: v.videoUrl, title: v.title)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Icon(Icons.image_outlined, size: 40, color: Colors.grey.shade300),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                      ),
                      Positioned(
                        bottom: 12, right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(6)),
                          child: Text(v.duration, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v.title, style: AppTextStyles.h3),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.visibility_rounded, size: 14, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text('${v.views} VIEWS', style: AppTextStyles.labelCaps.copyWith(fontSize: 9)),
                            const Spacer(),
                            Text(v.category.toUpperCase(), style: AppTextStyles.labelCaps.copyWith(color: AppColors.primaryGreen, fontSize: 9)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTrainingModules(AppLocalizations l10n) {
    final modules = [
      {'title': 'Soil Testing 101', 'prog': 0.8},
      {'title': 'Crop Rotation Basics', 'prog': 0.3},
      {'title': 'Modern Irrigation Methods', 'prog': 0.1},
      {'title': 'Pest Management Advanced', 'prog': 0.5},
    ];
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 16),
      itemBuilder: (ctx, i) {
        final m = modules[i];
        final prog = m['prog'] as double;
        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.school_rounded, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m['title'] as String, style: AppTextStyles.bodyBold),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: prog, 
                        minHeight: 6, 
                        backgroundColor: Colors.grey.shade100, 
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('${(prog * 100).toInt()}% COMPLETED', style: AppTextStyles.badgeText.copyWith(color: Colors.grey.shade400)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
