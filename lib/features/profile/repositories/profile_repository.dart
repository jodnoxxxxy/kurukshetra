import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kurukshetra/features/profile/models/farmer_profile.dart';

abstract class ProfileRepository {
  Future<FarmerProfile> getFarmerProfile();
  Future<void> updateFarmerProfile(FarmerProfile profile);
  Future<void> logout();
}

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<FarmerProfile> getFarmerProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final docId = prefs.getString('auth_token');

    if (docId == null) {
      throw Exception('Not logged in');
    }

    if (docId == 'demo_farmer') {
      return FarmerProfile(
        id: 'demo_farmer',
        name: 'Demo Farmer',
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

    final docMap = await FirebaseFirestore.instance.collection('farmers').doc(docId).get();
    
    if (!docMap.exists) {
      throw Exception('Profile not found in Firestore');
    }

    return FarmerProfile.fromJson(docMap.data()!, docMap.id);
  }

  @override
  Future<void> updateFarmerProfile(FarmerProfile profile) async {
    await FirebaseFirestore.instance.collection('farmers').doc(profile.id).update(profile.toJson());
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
