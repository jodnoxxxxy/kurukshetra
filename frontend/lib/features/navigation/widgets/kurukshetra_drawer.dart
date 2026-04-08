import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';
import 'package:kurukshetra/features/support/widgets/support_assistant_sheet.dart';

class KurukshetraDrawer extends ConsumerWidget {
  const KurukshetraDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // 1. HEADER SECTION
          _buildDrawerHeader(context, profile),
          
          const SizedBox(height: 12),
          
          // 2. MENU ITEMS SECTION
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _DrawerItem(
                  icon: Icons.person_outline_rounded,
                  title: 'My Profile',
                  onTap: () => _navigateTo(context, '/profile/edit'),
                ),
                _DrawerItem(
                  icon: Icons.agriculture_rounded,
                  title: 'My Farm',
                  onTap: () => _navigateTo(context, '/profile/farm'),
                ),
                _DrawerItem(
                  icon: Icons.analytics_rounded,
                  title: 'Farm Analytics',
                  onTap: () => _navigateTo(context, '/profile/analytics'),
                ),
                _DrawerItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  onTap: () => _navigateTo(context, '/profile/notifications'),
                ),
                
                // 3. DIVIDER
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F1F1)),
                ),
                
                // 4. SECOND SECTION
                _DrawerItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => const SupportAssistantSheet(),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => _navigateTo(context, '/profile/settings'),
                ),
              ],
            ),
          ),
          
          // 5. LOGOUT (AT BOTTOM)
          _buildLogoutItem(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, dynamic profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white,
              child: Icon(Icons.person_rounded, size: 42, color: Color(0xFF2E7D32)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            profile?.name ?? 'Farmer',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kurukshetra Farmer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: _DrawerItem(
        icon: Icons.logout_rounded,
        title: 'Logout',
        color: Colors.red.shade600,
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context);
    context.push(route);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.go('/login');
              },
              child: Text('Logout', style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}

// REUSABLE WIDGET: _DrawerItem
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? const Color(0xFF263238);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: effectiveColor.withValues(alpha: 0.05),
          hoverColor: effectiveColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: effectiveColor, size: 24),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: effectiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
