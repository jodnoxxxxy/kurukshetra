import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/core/widgets/section_header.dart';
import 'package:kurukshetra/core/widgets/list_tile_card.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';
import 'package:kurukshetra/features/profile/widgets/profile_card.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/core/widgets/language_selection_sheet.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileProvider);
    final currentLanguage = ref.watch(languageProvider);

    if (profileState.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9FBF9),
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
      );
    }

    final profile = profileState.profile;
    if (profile == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FBF9),
        appBar: AppBar(title: Text(l10n.myProfile), backgroundColor: Colors.white, elevation: 0),
        body: Center(child: Text(profileState.error ?? l10n.errorLabel)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            title: Text(l10n.myProfile, style: AppTextStyles.h1.copyWith(fontSize: 20)),
            backgroundColor: const Color(0xFFF9FBF9),
            elevation: 0,
            centerTitle: false,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ProfileCard(
                  profile: profile,
                  onEdit: () => context.push('/profile/edit'),
                ),
                const SizedBox(height: 32),

                SectionHeader(title: l10n.farmDetails, icon: Icons.agriculture_rounded),
                ListTileCard(
                  icon: Icons.description_rounded,
                  title: l10n.landRecords,
                  subtitle: '${profile.landRecords.length} ${l10n.recordsLabel}',
                  onTap: () => context.push('/profile/land-records'),
                ),
                ListTileCard(
                  icon: Icons.history_rounded,
                  title: l10n.cropHistory,
                  subtitle: '${profile.cropHistory.length} ${l10n.cropsTrackedLabel}',
                  onTap: () => context.push('/profile/crop-history'),
                ),
                const SizedBox(height: 32),

                SectionHeader(title: l10n.preferences, icon: Icons.settings_rounded),
                ListTileCard(
                  icon: Icons.translate_rounded,
                  title: l10n.language,
                  subtitle: currentLanguage,
                  onTap: () => _showLanguageDialog(context, ref),
                ),
                ListTileCard(
                  icon: Icons.notifications_rounded,
                  title: l10n.notifications,
                  subtitle: l10n.notificationsSubtitle,
                  onTap: () => context.push('/profile/notifications'),
                ),
                const SizedBox(height: 32),

                SectionHeader(title: l10n.account, icon: Icons.assessment_rounded),
                 ListTileCard(
                  icon: Icons.analytics_rounded,
                  title: l10n.farmReports,
                  subtitle: l10n.farmReportsSubtitle,
                  onTap: () => context.push('/profile/reports'),
                ),
                ListTileCard(
                  icon: Icons.verified_user_rounded,
                  title: l10n.organicCertification,
                  subtitle: '${profile.organicScore.toInt()}% ${l10n.verifiedTitle}',
                  onTap: () => context.push('/profile/organic'),
                ),
                const SizedBox(height: 32),

                SectionHeader(title: l10n.support, icon: Icons.help_rounded),
                ListTileCard(
                  icon: Icons.support_agent_rounded,
                  title: l10n.helpSupport,
                  subtitle: l10n.helpSupportSubtitle,
                  onTap: () => context.push('/profile/help'),
                ),
                ListTileCard(
                  icon: Icons.logout_rounded,
                  title: l10n.logout,
                  iconColor: Colors.redAccent,
                  onTap: () => _showLogoutDialog(context, ref),
                  trailing: const SizedBox.shrink(),
                ),
                
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Text('Farmer v1.0.0', style: AppTextStyles.labelCaps.copyWith(color: Colors.grey.shade400, fontSize: 10)),
                      const SizedBox(height: 6),
                      Text('Secure Integrated Farming System', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(AppLocalizations.of(context)!.logout, style: AppTextStyles.h3),
        content: Text(AppLocalizations.of(context)!.logoutConfirm, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel, style: AppTextStyles.badgeText.copyWith(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(profileProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LanguageSelectionSheet(),
    );
  }
}

