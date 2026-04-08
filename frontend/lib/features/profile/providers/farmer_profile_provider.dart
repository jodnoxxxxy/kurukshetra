import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Temporarily disabled
import 'package:kurukshetra/features/auth/services/firebase_user_service.dart';
import 'package:kurukshetra/features/auth/providers/auth_provider.dart';

// Provider for farmer profile data from Firebase
final farmerProfileProvider = StreamProvider.family<Map<String, dynamic>?, String>((ref, userId) {
  final firebaseUserService = ref.watch(firebaseUserServiceProvider);
  return firebaseUserService.streamFarmerProfile(userId);
});

// Provider for current farmer profile (uses current user ID)
final currentFarmerProfileProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  // Temporarily disabled Firebase Auth - will use a mock user ID
  // final firebaseAuth = FirebaseAuth.instance;
  // final userId = firebaseAuth.currentUser?.uid;
  
  // Using a mock user ID for now
  final userId = 'demo_farmer_123'; // Temporary demo user
  
  if (userId == null) {
    return Stream.value(null);
  }
  
  final firebaseUserService = ref.watch(firebaseUserServiceProvider);
  return firebaseUserService.streamFarmerProfile(userId);
});

// Provider for updating farmer profile
final updateFarmerProfileProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, updates) async {
  // Temporarily disabled Firebase Auth
  // final firebaseAuth = FirebaseAuth.instance;
  // final userId = firebaseAuth.currentUser?.uid;
  
  final userId = 'demo_farmer_123'; // Temporary demo user
  
  if (userId == null) {
    throw Exception('User not authenticated');
  }
  
  final firebaseUserService = ref.watch(firebaseUserServiceProvider);
  await firebaseUserService.updateFarmerProfile(userId, updates);
});
