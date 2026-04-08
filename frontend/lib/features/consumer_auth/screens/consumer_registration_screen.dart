import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/utils/validation_utils.dart';
import '../models/consumer_model.dart';
import '../providers/consumer_auth_provider.dart';
import '../widgets/input_field.dart';
import '../widgets/register_button.dart';

class ConsumerRegistrationScreen extends ConsumerStatefulWidget {
  const ConsumerRegistrationScreen({super.key});

  @override
  ConsumerState<ConsumerRegistrationScreen> createState() => _ConsumerRegistrationScreenState();
}

class _ConsumerRegistrationScreenState extends ConsumerState<ConsumerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final consumer = ConsumerModel(
      id: '', // Will be assigned by backend
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      pincode: _pincodeController.text.trim(),
    );

    try {
      await ref.read(consumerAuthProvider.notifier).register(consumer, _passwordController.text.trim());
      
      if (mounted) {
        setState(() => _isLoading = false);
        context.push('/consumer-dashboard');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration Failed: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Consumer Registration', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join Kurukshetra Marketplace',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Buy fresh organic crops directly from verified farmers.',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
                ),
                const SizedBox(height: 32),
                
                const Text('Basic Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ConsumerInputField(
                  label: 'Full Name',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (val) => val!.isEmpty ? 'Name is required' : null,
                ),
                ConsumerInputField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  prefixIcon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                  validator: (val) => val!.length != 10 ? 'Enter valid 10-digit number' : null,
                ),
                ConsumerInputField(
                  label: 'Email',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val!.isEmpty || !ValidationUtils.isValidEmail(val) ? 'Enter valid email' : null,
                ),
                ConsumerInputField(
                  label: 'Password',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (val) => val!.length < 6 ? 'Minimum 6 characters required' : null,
                ),

                const SizedBox(height: 16),
                const Text('Delivery Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ConsumerInputField(
                  label: 'Delivery Address',
                  controller: _addressController,
                  prefixIcon: Icons.home_outlined,
                  validator: (val) => val!.isEmpty ? 'Address is required' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ConsumerInputField(
                        label: 'City',
                        controller: _cityController,
                        prefixIcon: Icons.location_city_outlined,
                        validator: (val) => val!.isEmpty ? 'City required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: ConsumerInputField(
                        label: 'Pincode',
                        controller: _pincodeController,
                        keyboardType: TextInputType.number,
                        validator: (val) => val!.length != 6 ? 'Invalid' : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                ConsumerRegisterButton(
                  text: 'Register Account',
                  isLoading: _isLoading,
                  onPressed: _register,
                ),
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?', style: TextStyle(color: Colors.grey.shade600)),
                    TextButton(
                      onPressed: () {
                        if (context.canPop()) {
                           context.pop();
                        } else {
                           context.push('/login');
                        }
                      },
                      child: const Text('Login Here', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
