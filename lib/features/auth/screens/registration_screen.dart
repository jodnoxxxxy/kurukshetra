import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _currentStep = 1;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedDistrict;
  String? _selectedTaluka;
  String? _selectedVillage;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else if (_currentStep == 3) {
      _completeRegistration();
    }
  }

  bool _isRegistering = false;

  void _completeRegistration() async {
    if (_isRegistering) return;
    
    // Validate required fields
    if (_nameController.text.isEmpty || _mobileController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields'), backgroundColor: Colors.red)
      );
      return;
    }
    
    setState(() { _isRegistering = true; });

    try {
      // Call backend registration API
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/v1/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': '${_mobileController.text.trim()}@farmer.local',
          'phone': _mobileController.text.trim(),
          'password': _passwordController.text.trim(),
          'district': _selectedDistrict ?? 'Unknown',
          'taluka': _selectedTaluka ?? 'Unknown',
          'village': _selectedVillage ?? 'Unknown',
          'location': '${_selectedDistrict}, ${_selectedTaluka}, ${_selectedVillage}',
          'state': _selectedDistrict,
        }),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Connection timeout. Make sure the backend server is running on http://localhost:5000'),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final token = responseData['data']['token'];
        
        // Save session data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_id', responseData['data']['farmer']['id'] ?? 'farmer_${_mobileController.text}');
        await prefs.setString('user_name', _nameController.text.trim());
        await prefs.setString('user_role', 'farmer');
        
        if (mounted) {
          setState(() {
            _isRegistering = false;
            _currentStep = 4;
          });
        }
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Registration failed');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() { _isRegistering = false; });
        final errorMsg = e.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration Failed: $errorMsg'), 
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Bypass (Demo)', 
              textColor: Colors.white,
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('auth_token', 'demo_farmer');
                await prefs.setString('user_id', 'demo_farmer');
                await prefs.setString('user_role', 'farmer');
                await prefs.setString('user_name', _nameController.text.isEmpty ? 'Demo Farmer' : _nameController.text);
                if (mounted) context.go('/');
              }
            ),
          )
        );
      }
    }
  }

  Widget _buildLoadingIndicator(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        const SizedBox(height: 12),
        Text(
          'Connecting to server...',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
        ),
      ],
    );
  }

  void _showLocationPicker(String title, List<String> items, Function(String) onSelect, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.selectTitle} $title',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index]),
                      onTap: () {
                        onSelect(items[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep1(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.personalInformation,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.fullName,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: l10n.mobileNumber,
            prefixIcon: const Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _nextStep,
          child: Text(l10n.sendOtp),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', 'demo_farmer');
            await prefs.setString('user_id', 'demo_farmer');
            await prefs.setString('user_role', 'farmer');
            await prefs.setString('user_name', 'Demo Farmer');
            if (mounted) context.go('/');
          },
          child: const Text('Continue with Demo', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildStep2(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.verifyOtp,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.sentTo} ${_mobileController.text}',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(letterSpacing: 8),
          decoration: InputDecoration(
            labelText: l10n.enterOtpHint,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _nextStep,
          child: Text(l10n.verify),
        ),
      ],
    );
  }

  Widget _buildStep3(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.selectLocation,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        
        // District
        ListTile(
          title: Text(_selectedDistrict ?? l10n.selectDistrict),
          trailing: const Icon(Icons.arrow_drop_down),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          onTap: () => _showLocationPicker(
            l10n.district,
            ['Pune', 'Nashik', 'Nagpur', 'Aurangabad'],
            (val) => setState(() {
              _selectedDistrict = val;
              _selectedTaluka = null;
              _selectedVillage = null;
            }),
            l10n,
          ),
        ),
        const SizedBox(height: 16),

        // Taluka
        ListTile(
          title: Text(_selectedTaluka ?? l10n.selectTaluka),
          trailing: const Icon(Icons.arrow_drop_down),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          onTap: _selectedDistrict == null ? null : () => _showLocationPicker(
            l10n.taluka,
            ['Taluka 1', 'Taluka 2', 'Taluka 3'],
            (val) => setState(() {
              _selectedTaluka = val;
              _selectedVillage = null;
            }),
            l10n,
          ),
        ),
        const SizedBox(height: 16),

        // Village
        ListTile(
          title: Text(_selectedVillage ?? l10n.selectVillage),
          trailing: const Icon(Icons.arrow_drop_down),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          onTap: _selectedTaluka == null ? null : () => _showLocationPicker(
            l10n.village,
            ['Village A', 'Village B', 'Village C'],
            (val) => setState(() => _selectedVillage = val),
            l10n,
          ),
        ),

        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: (_selectedDistrict != null && _selectedTaluka != null && _selectedVillage != null && !_isRegistering) 
              ? _nextStep 
              : null,
          child: _isRegistering 
              ? _buildLoadingIndicator(l10n)
              : Text(l10n.continueButton),
        ),
        if (_isRegistering)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('auth_token', 'demo_farmer');
                await prefs.setString('user_id', 'demo_farmer');
                await prefs.setString('user_role', 'farmer');
                await prefs.setString('user_name', _nameController.text.isEmpty ? 'Demo' : _nameController.text);
                if (mounted) context.go('/');
              },
              child: const Text('Taking too long? Use Demo Mode', style: TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.underline)),
            ),
          ),
      ],
    );
  }

  Widget _buildStep4(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.primaryGreen,
          size: 80,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.accountCreated,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.successfullyRegisteredFarmer,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => context.go('/'),
          child: Text(l10n.goToHome),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.registrationTitle),
        automaticallyImplyLeading: _currentStep < 4,
        leading: _currentStep < 4
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (_currentStep > 1) {
                    setState(() => _currentStep--);
                  } else {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/role-selection');
                    }
                  }
                },
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _currentStep == 1
                ? _buildStep1(l10n)
                : _currentStep == 2
                    ? _buildStep2(l10n)
                    : _currentStep == 3
                        ? _buildStep3(l10n)
                        : _buildStep4(l10n),
          ),
        ),
      ),
    );
  }
}
