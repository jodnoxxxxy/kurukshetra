import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import '../providers/admin_auth_provider.dart';
import 'admin_upload_video_screen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final admin = ref.watch(adminAuthProvider);

    if (!admin.isAuthenticated) {
      return Scaffold(body: Center(child: Text(l10n.unauthorized)));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(l10n.adminDashboardTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(adminAuthProvider.notifier).logout();
              context.go('/role-selection');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.systemOverview,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Statistics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(Icons.agriculture, l10n.totalFarmersLabel, '1,284', Colors.green),
                _buildStatCard(Icons.people, l10n.consumersLabel, '5,492', Colors.blue),
                _buildStatCard(Icons.inventory, l10n.activeProductsLabel, '342', Colors.orange),
                _buildStatCard(Icons.payments, l10n.revenueLabel, l10n.revenueValue, Colors.purple),
              ],
            ),
            
            const SizedBox(height: 32),
            Text(
              l10n.managementModules,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildModuleTile(context, Icons.verified_user, l10n.verifyFarmersLabel, l10n.pendingVerificationDesc, Colors.green),
            _buildModuleTile(
                context, 
                Icons.upload_file, 
                'Upload Educational Videos', 
                'Manage Learning Content', 
                Colors.teal,
                onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AdminUploadVideoScreen())
                    );
                }
            ),
            _buildModuleTile(context, Icons.report_problem, l10n.flagsIssuesLabel, l10n.customerComplaintsDesc, Colors.red),
            _buildModuleTile(context, Icons.analytics, l10n.marketAnalyticsLabel, l10n.priceTrendsDesc, Colors.indigo),
            _buildModuleTile(context, Icons.settings, l10n.systemConfigLabel, l10n.appSettingsDesc, Colors.grey),
            
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Kurukshetra Admin v1.0.4',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildModuleTile(BuildContext context, IconData icon, String title, String subtitle, Color color, {VoidCallback? onTap}) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap ?? () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.moduleComingSoon(title))),
          );
        },
      ),
    );
  }
}
