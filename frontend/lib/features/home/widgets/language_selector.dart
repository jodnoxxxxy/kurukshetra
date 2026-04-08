import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);

    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.language,
          color: Colors.white,
          size: 20,
        ),
      ),
      onSelected: (language) => _changeLanguage(context, ref, language),
      itemBuilder: (context) => [
        _buildLanguageItem('🇬🇧 English', 'English', currentLanguage),
        _buildLanguageItem('🇮🇳 मराठी', 'Marathi', currentLanguage),
        _buildLanguageItem('🇮🇳 हिन्दी', 'Hindi', currentLanguage),
      ],
    );
  }

  PopupMenuItem<String> _buildLanguageItem(String flag, String language, String currentLanguage) {
    final isSelected = currentLanguage == language;
    
    return PopupMenuItem<String>(
      value: language,
      child: Row(
        children: [
          Text(flag),
          const SizedBox(width: 12),
          Text(language),
          const Spacer(),
          if (isSelected)
            const Icon(
              Icons.check,
              color: Colors.green,
              size: 20,
            ),
        ],
      ),
    );
  }

  Future<void> _changeLanguage(BuildContext context, WidgetRef ref, String language) async {
    try {
      // Update the language provider
      ref.read(languageProvider.notifier).updateLanguage(language);
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('preferred_language', language);
      
      // Update profile if available
      try {
        await ref.read(profileProvider.notifier).updateLanguage(language);
      } catch (e) {
        // Profile might not be loaded yet, that's okay
        print('Profile not available yet: $e');
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to $language'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change language: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
