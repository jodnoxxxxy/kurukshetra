import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.eco, size: 100, color: AppColors.primaryGreen),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.welcomeToKurukshetra,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.selectRole,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 48),

              _buildRoleCard(
                context,
                title: AppLocalizations.of(context)!.farmer,
                subtitle: AppLocalizations.of(context)!.farmerSubtitle,
                icon: Icons.agriculture,
                onTap: () => context.push('/register'),
              ),
              
              const SizedBox(height: 16),

              _buildRoleCard(
                context,
                title: AppLocalizations.of(context)!.consumer,
                subtitle: AppLocalizations.of(context)!.consumerSubtitle,
                icon: Icons.shopping_bag_outlined,
                onTap: () => context.push('/consumer-register'),
              ),

              const SizedBox(height: 48),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.alreadyHaveAccount, style: TextStyle(color: Colors.grey.shade600)),
                  TextButton(
                    onPressed: () => context.push('/login'),
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              TextButton.icon(
                onPressed: () => context.push('/admin-login'),
                icon: const Icon(Icons.admin_panel_settings, size: 18, color: Colors.grey),
                label: Text(AppLocalizations.of(context)!.adminPortal, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300, width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: AppColors.primaryGreen.withValues(alpha: 0.1),
        highlightColor: AppColors.primaryGreen.withValues(alpha: 0.1),
        splashColor: AppColors.primaryGreen.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.3)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.primaryGreen, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
