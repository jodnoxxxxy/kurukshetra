import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import '../providers/admin_auth_provider.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _idController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;
    if (_idController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseFillAllFields)),
      );
      return;
    }

    setState(() => _isLoading = true);
    final success = await ref.read(adminAuthProvider.notifier).login(
      _idController.text.trim(),
      _passController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go('/admin-dashboard');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.read(adminAuthProvider).error ?? l10n.loginFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.adminPortal, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () => context.go('/role-selection'),
                borderRadius: BorderRadius.circular(40),
                child: const Icon(Icons.admin_panel_settings, size: 80, color: Colors.indigo),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.adminPortal, // Reusing Admin Portal as header or add System Admin to arb
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.adminLoginDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 48),
              
              // ID Field
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.adminIdLabel,
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Password Field
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.passwordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(AppLocalizations.of(context)!.loginButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go('/role-selection'),
                child: Text(AppLocalizations.of(context)!.returnToAppSelection, style: const TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
