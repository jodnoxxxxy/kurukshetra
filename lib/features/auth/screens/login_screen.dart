import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/consumer_auth/providers/consumer_auth_provider.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Toggle role: true = Farmer, false = Consumer
  bool isFarmerLogin = true;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // Basic validation
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.validCredentialsError)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isFarmerLogin) {
        final phone = _idController.text.trim();
        final password = _passwordController.text.trim();

        if (phone == 'demo' && password == 'demo') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', 'demo_farmer');
          await prefs.setString('user_role', 'farmer');
          if (mounted) {
            context.go('/');
          }
          return;
        }

        final query = await FirebaseFirestore.instance.collection('farmers')
            .where('phone', isEqualTo: phone)
            .where('password', isEqualTo: password)
            .get();

        if (query.docs.isEmpty) {
          throw Exception('Invalid Farmer Phone or Password.');
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', query.docs.first.id);
        await prefs.setString('user_role', 'farmer');
        if (mounted) {
          context.go('/');
        }
      } else {
        // Consumer Login via existing provider hook
        await ref.read(consumerAuthProvider.notifier).login(_idController.text.trim(), _passwordController.text.trim());
        final consumer = ref.read(consumerAuthProvider);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', consumer?.id ?? 'consumer_token');
        await prefs.setString('user_role', 'consumer');
        if (mounted) {
          context.go('/consumer-dashboard');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.loginFailedError}: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/role-selection');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Logo
              Center(
                child: InkWell(
                  onTap: () => context.go('/role-selection'),
                  borderRadius: BorderRadius.circular(40),
                  child: const Icon(Icons.eco, size: 80, color: AppColors.primaryGreen),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.signInToKurukshetra,
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 40),

              // Toggle Button (Farmer | Consumer)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                            isFarmerLogin = true;
                            _idController.clear();
                            _passwordController.clear();
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isFarmerLogin ? AppColors.primaryGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.farmer,
                              style: TextStyle(
                                color: isFarmerLogin ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                            isFarmerLogin = false;
                            _idController.clear();
                            _passwordController.clear();
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isFarmerLogin ? AppColors.primaryGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.consumer,
                              style: TextStyle(
                                color: !isFarmerLogin ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Input Fields
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: isFarmerLogin ? AppLocalizations.of(context)!.farmerIdHint : AppLocalizations.of(context)!.consumerEmailHint,
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.passwordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 32),

              // Primary Login Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(AppLocalizations.of(context)!.loginButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),

              Center(
                child: Text(AppLocalizations.of(context)!.needAnAccount, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 16),

              // Register Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/register'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(AppLocalizations.of(context)!.registerAsFarmer, style: const TextStyle(color: AppColors.primaryGreen, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/consumer-register'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.blue.shade700),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(AppLocalizations.of(context)!.registerAsConsumer, style: TextStyle(color: Colors.blue.shade700, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
