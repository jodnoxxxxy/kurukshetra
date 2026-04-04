import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../providers/consumer_auth_provider.dart';
import '../widgets/input_field.dart';
import '../widgets/register_button.dart';

class ConsumerLoginScreen extends ConsumerStatefulWidget {
  const ConsumerLoginScreen({super.key});

  @override
  ConsumerState<ConsumerLoginScreen> createState() => _ConsumerLoginScreenState();
}

class _ConsumerLoginScreenState extends ConsumerState<ConsumerLoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  
  bool _otpSent = false;
  bool _isLoading = false;

  void _sendOtp() {
    if (_phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid 10-digit number')));
      return;
    }
    setState(() => _otpSent = true);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP sent! Use 123456 as mock.')));
  }

  void _verifyLogin() async {
    if (_otpController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(consumerAuthProvider.notifier).login(_phoneController.text.trim(), _otpController.text.trim());
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/consumer-dashboard');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Failed: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Consumer Login', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.storefront_outlined, size: 80, color: AppColors.primaryGreen),
              const SizedBox(height: 24),
              const Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Login to directly connect with farmers and buy fresh organic produce.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
              ),
              const SizedBox(height: 48),

              ConsumerInputField(
                label: 'Mobile Number',
                controller: _phoneController,
                prefixIcon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                validator: (val) => val!.length != 10 ? 'Enter valid 10-digit number' : null,
              ),

              if (_otpSent) ...[
                const SizedBox(height: 16),
                ConsumerInputField(
                  label: 'Enter 6-digit OTP',
                  controller: _otpController,
                  prefixIcon: Icons.message_outlined,
                  keyboardType: TextInputType.number,
                ),
              ],

              const SizedBox(height: 40),

              if (!_otpSent)
                ConsumerRegisterButton(
                  text: 'Send OTP',
                  onPressed: _sendOtp,
                )
              else
                ConsumerRegisterButton(
                  text: 'Verify & Login',
                  isLoading: _isLoading,
                  onPressed: _verifyLogin,
                ),

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New to Kurukshetra?', style: TextStyle(color: Colors.grey.shade600)),
                  TextButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.push('/consumer-register');
                      }
                    },
                    child: const Text('Register Here', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
