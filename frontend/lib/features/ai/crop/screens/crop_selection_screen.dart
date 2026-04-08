import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/core/widgets/app_card.dart';
import '../providers/advisory_provider.dart';
import '../models/crop_advisory.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';

class CropSelectionScreen extends ConsumerStatefulWidget {
  const CropSelectionScreen({super.key});

  @override
  ConsumerState<CropSelectionScreen> createState() => _CropSelectionScreenState();
}

class _CropSelectionScreenState extends ConsumerState<CropSelectionScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(cropCategoriesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, l10n),
          _buildSearchOverlay(l10n),
          categoriesAsync.when(
            data: (categories) {
              final filteredCategories = categories.map((cat) {
                final filteredCrops = cat.crops.where((crop) =>
                    crop.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                return CropCategory(name: cat.name, crops: filteredCrops);
              }).where((cat) => cat.crops.isNotEmpty).toList();

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = filteredCategories[index];
                      return _buildCategorySection(context, category);
                    },
                    childCount: filteredCategories.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))),
            error: (err, _) => SliverFillRemaining(child: Center(child: Text(l10n.failedToLoadStages(err.toString())))),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 180,
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
          l10n.cropSelectionTitle,
          style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 20),
        ),
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
                right: -20,
                top: -20,
                child: Icon(Icons.eco_rounded, size: 140, color: Colors.white.withValues(alpha: 0.1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchOverlay(AppLocalizations l10n) {
    return SliverToBoxAdapter(
      child: Transform.translate(
        offset: const Offset(0, -32),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search for crops...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                icon: const Icon(Icons.search_rounded, color: AppColors.primaryGreen),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, CropCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 10),
              Text(
                L10nUtils.translateCategory(context, category.name),
                style: AppTextStyles.h3.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.82,
          ),
          itemCount: category.crops.length,
          itemBuilder: (context, i) => _buildAdvancedCropCard(context, category.crops[i], category.name),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildAdvancedCropCard(BuildContext context, CropInfo crop, String categoryName) {
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: () => _selectSowingDate(context, ref, crop),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Hero(
                    tag: 'crop_${crop.name}',
                    child: Image.network(
                      crop.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(color: Colors.grey.shade100, child: const Icon(Icons.grass_rounded, color: Colors.grey)),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.add_rounded, color: AppColors.primaryGreen, size: 18),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10nUtils.translateCrop(context, crop.name.toLowerCase()),
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  categoryName.toUpperCase(),
                  style: AppTextStyles.labelCaps.copyWith(color: AppColors.primaryGreen, fontSize: 8),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectSowingDate(BuildContext context, WidgetRef ref, CropInfo crop) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryGreen, onPrimary: Colors.white, onSurface: Colors.black),
        ),
        child: child!,
      ),
    );

    if (picked != null && context.mounted) {
      ref.read(selectedCropProvider.notifier).setCrop(crop);
      ref.read(selectedSowingDateProvider.notifier).setDate(picked);
      context.push('/advisory-timeline');
    }
  }
}
