import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/features/profile/models/farmer_profile.dart';

abstract class ProfileRepository {
  Future<FarmerProfile> getFarmerProfile();
  Future<void> updateFarmerProfile(FarmerProfile profile);
  Future<void> logout();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final String _baseUrl = 'http://localhost:5000/api/v1/farmers';

  @override
  Future<FarmerProfile> getFarmerProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not logged in');
    }

    if (token == 'demo_farmer') {
      return FarmerProfile(
        id: 'demo_farmer',
        name: prefs.getString('user_name') ?? 'Demo Farmer',
        phone: 'demo',
        email: 'demo@farmer.com',
        location: 'Demo Village, India',
        farmArea: 10.0,
        profilePhoto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1470&auto=format&fit=crop',
        isVerified: true,
        organicScore: 90.0,
        organicStatus: 'Certified Organic',
        farmerId: 'FARM-DEMO',
        memberSince: DateTime.now().subtract(const Duration(days: 365)),
        preferredLanguage: 'English',
      );
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data']['farmer'];
        
        // Map backend farmer to frontend model
        return FarmerProfile(
          id: data['id'],
          name: data['name'],
          phone: data['phone'] ?? '',
          email: data['email'] ?? '',
          location: data['location'] ?? 'Unknown Location',
          farmArea: 0.0, // Default for now
          profilePhoto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1470&auto=format&fit=crop',
          isVerified: data['verified'] ?? false,
          organicScore: 0.0,
          organicStatus: 'Not Verified',
          farmerId: 'FARM-${data['id'].toString().substring(0, 4).toUpperCase()}',
          memberSince: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
          preferredLanguage: data['languagePreference'] ?? 'English',
        );
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      // Return a minimal profile if backend is really down but we have prefs
      final name = prefs.getString('user_name') ?? 'Farmer';
      return FarmerProfile(
        id: 'fallback',
        name: name,
        phone: '',
        email: '',
        location: 'Offline Mode',
        farmArea: 0.0,
        profilePhoto: '',
        isVerified: false,
        organicScore: 0.0,
        organicStatus: '',
        farmerId: 'NA',
        memberSince: DateTime.now(),
        preferredLanguage: 'English',
      );
    }
  }

  @override
  Future<void> updateFarmerProfile(FarmerProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token == 'demo_farmer') return;

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': profile.name,
          'phone': profile.phone,
          'location': profile.location,
          'languagePreference': profile.preferredLanguage,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw e;
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('user_id');
    
    // Clear any other user-related data
    await prefs.remove('preferred_language');
    
    print('User logged out successfully');
  }
}
