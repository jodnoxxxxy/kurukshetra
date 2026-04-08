import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class LanguageSelectionSheet extends ConsumerWidget {
  const LanguageSelectionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLanguage = ref.watch(languageProvider);
    final languages = [
      {'flag': '🇬🇧', 'name': 'English', 'native': 'English'},
      {'flag': '🇮🇳', 'name': 'Marathi', 'native': 'मराठी'},
      {'flag': '🇮🇳', 'name': 'Hindi', 'native': 'हिन्दी'},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      decoration: const BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, 
              height: 4, 
              decoration: BoxDecoration(
                color: Colors.grey.shade200, 
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.selectLanguage, style: AppTextStyles.h2),
          const SizedBox(height: 24),
          ...languages.map((lang) {
            final isSelected = currentLanguage == lang['name'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  ref.read(languageProvider.notifier).updateLanguage(lang['name']!);
                  ref.read(profileProvider.notifier).updateLanguage(lang['name']!);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.05) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryGreen : Colors.grey.shade200, 
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          Text(lang['name']!, style: AppTextStyles.bodyBold),
                          Text(lang['native']!, style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const Spacer(),
                      if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen, size: 24),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
