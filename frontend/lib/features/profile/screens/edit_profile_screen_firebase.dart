import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/profile/providers/farmer_profile_provider.dart';
import 'package:kurukshetra/features/auth/services/firebase_user_service.dart';
import 'package:kurukshetra/features/auth/providers/auth_provider.dart';
import 'package:kurukshetra/core/utils/validation_utils.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _farmAreaController = TextEditingController();
  final _districtController = TextEditingController();
  final _talukaController = TextEditingController();
  
  String? _profilePhoto;
  String _selectedSoilType = 'LOAMY';
  bool _isLoading = false;
  bool _isInitialized = false;

  final List<String> _soilTypes = ['LOAMY', 'CLAY', 'SANDY', 'SILT', 'PEATY'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _farmAreaController.dispose();
    _districtController.dispose();
    _talukaController.dispose();
    super.dispose();
  }

  void _initializeFields(Map<String, dynamic>? profileData) {
    if (_isInitialized || profileData == null) return;
    
    try {
      _firstNameController.text = profileData['firstName'] ?? '';
      _lastNameController.text = profileData['lastName'] ?? '';
      _phoneController.text = profileData['phone'] ?? '';
      _emailController.text = profileData['email'] ?? '';
      _locationController.text = profileData['location'] ?? '';
      _farmAreaController.text = (profileData['farmArea'] ?? 0).toString();
      _districtController.text = profileData['district'] ?? '';
      _talukaController.text = profileData['taluka'] ?? '';
      _profilePhoto = profileData['profilePhoto'] ?? '';
      _selectedSoilType = profileData['soilType'] ?? 'LOAMY';
      _isInitialized = true;
    } catch (e) {
      print('Error initializing fields: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        setState(() {
          _profilePhoto = image.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image selected. Save to upload.'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final firebaseUserService = ref.read(firebaseUserServiceProvider);
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Prepare updated data
      final updates = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'fullName': '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'location': _locationController.text.trim(),
        'farmArea': double.parse(_farmAreaController.text.trim()),
        'district': _districtController.text.trim(),
        'taluka': _talukaController.text.trim(),
        'soilType': _selectedSoilType,
        if (_profilePhoto != null && _profilePhoto!.isNotEmpty) 'profilePhoto': _profilePhoto,
      };

      // Update in Firebase
      await firebaseUserService.updateFarmerProfile(userId, updates);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileData = ref.watch(currentFarmerProfileProvider);

    return profileData.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Text('Error loading profile: $error'),
        ),
      ),
      data: (data) {
        if (!_isInitialized) {
          _initializeFields(data);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9FBF9),
          appBar: AppBar(
            title: const Text(
              'Edit Profile',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            backgroundColor: const Color(0xFFF9FBF9),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Photo
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: _profilePhoto != null && _profilePhoto!.isNotEmpty && _profilePhoto!.startsWith('http')
                                      ? NetworkImage(_profilePhoto!)
                                      : null,
                                  backgroundColor: Colors.grey.shade200,
                                  child: (_profilePhoto == null || _profilePhoto!.isEmpty)
                                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                  ),
                                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tap to change photo',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  _buildSectionTitle('Personal Information'),
                  _buildTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter first name' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter last name' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.length < 10) ? 'Please enter valid phone' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || !ValidationUtils.isValidEmail(v)) ? 'Please enter valid email' : null,
                  ),

                  const SizedBox(height: 32),
                  _buildSectionTitle('Farm Information'),
                  _buildTextField(
                    controller: _districtController,
                    label: 'District',
                    icon: Icons.location_city,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter district' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _talukaController,
                    label: 'Taluka',
                    icon: Icons.location_on_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter taluka' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location/Village',
                    icon: Icons.home_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter location' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildSoilTypeDropdown(),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _farmAreaController,
                    label: 'Farm Area (hectares)',
                    icon: Icons.agriculture_outlined,
                    keyboardType: TextInputType.number,
                    validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Please enter valid area' : null,
                  ),

                  const SizedBox(height: 48),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primaryGreen.withAlpha(102),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                          : const Text(
                            'SAVE CHANGES',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.primaryGreen,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 22),
        suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.all(16), child: suffix) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: label,
      ),
    );
  }

  Widget _buildSoilTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSoilType,
      decoration: InputDecoration(
        labelText: 'Soil Type',
        labelStyle: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
        prefixIcon: const Icon(Icons.landscape, color: AppColors.primaryGreen, size: 22),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      items: _soilTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() => _selectedSoilType = newValue);
        }
      },
    );
  }
}
