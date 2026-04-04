import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/features/profile/models/farmer_profile.dart';
import 'package:kurukshetra/features/profile/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

class ProfileState {
  final FarmerProfile? profile;
  final bool isLoading;
  final String? error;

  ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    FarmerProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  late final ProfileRepository _repository;

  @override
  ProfileState build() {
    _repository = ref.read(profileRepositoryProvider);
    _loadProfile();
    return ProfileState(isLoading: true);
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _repository.getFarmerProfile();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? location,
    double? farmArea,
    String? profilePhoto,
  }) async {
    if (state.profile == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final updatedProfile = state.profile!.copyWith(
        name: name,
        phone: phone,
        email: email,
        location: location,
        farmArea: farmArea,
        profilePhoto: profilePhoto,
      );

      await _repository.updateFarmerProfile(updatedProfile);
      state = state.copyWith(profile: updatedProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateLanguage(String language) async {
    if (state.profile == null) return;

    try {
      final updatedProfile = state.profile!.copyWith(preferredLanguage: language);
      await _repository.updateFarmerProfile(updatedProfile);
      
      // Save to SharedPreferences for app-wide language setting
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('preferred_language', language);
      
      state = state.copyWith(profile: updatedProfile);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateNotificationPreferences(String key, bool value) async {
    if (state.profile == null) return;

    try {
      final updatedPreferences = Map<String, bool>.from(state.profile!.notificationPreferences);
      updatedPreferences[key] = value;

      final updatedProfile = state.profile!.copyWith(
        notificationPreferences: updatedPreferences,
      );

      await _repository.updateFarmerProfile(updatedProfile);
      state = state.copyWith(profile: updatedProfile);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> addLandRecord(LandRecord landRecord) async {
    if (state.profile == null) return;

    try {
      final updatedLandRecords = [...state.profile!.landRecords, landRecord];
      final updatedProfile = state.profile!.copyWith(landRecords: updatedLandRecords);

      await _repository.updateFarmerProfile(updatedProfile);
      state = state.copyWith(profile: updatedProfile);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateLandRecord(LandRecord landRecord) async {
    if (state.profile == null) return;

    try {
      final updatedLandRecords = state.profile!.landRecords.map((record) {
        return record.id == landRecord.id ? landRecord : record;
      }).toList();

      final updatedProfile = state.profile!.copyWith(landRecords: updatedLandRecords);

      await _repository.updateFarmerProfile(updatedProfile);
      state = state.copyWith(profile: updatedProfile);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteLandRecord(String landRecordId) async {
    if (state.profile == null) return;

    try {
      final updatedLandRecords = state.profile!.landRecords
          .where((record) => record.id != landRecordId)
          .toList();

      final updatedProfile = state.profile!.copyWith(landRecords: updatedLandRecords);

      await _repository.updateFarmerProfile(updatedProfile);
      state = state.copyWith(profile: updatedProfile);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> addCropHistory(CropHistory cropHistory) async {
    if (state.profile == null) return;

    try {
      final updatedCropHistory = [...state.profile!.cropHistory, cropHistory];
      final updatedProfile = state.profile!.copyWith(cropHistory: updatedCropHistory);

      await _repository.updateFarmerProfile(updatedProfile);
      state = state.copyWith(profile: updatedProfile);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updatePaymentDetails(PaymentDetails paymentDetails) async {
    if (state.profile == null) return;

    try {
      final updatedProfile = state.profile!.copyWith(paymentDetails: paymentDetails);
      await _repository.updateFarmerProfile(updatedProfile);
      state = state.copyWith(profile: updatedProfile);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      state = ProfileState();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(() {
  return ProfileNotifier();
});

// Language provider for app-wide language management
class LanguageNotifier extends Notifier<String> {
  @override
  String build() {
    _loadSavedLanguage();
    return 'English';
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('preferred_language');
      if (saved != null && saved.isNotEmpty) {
        state = saved;
      }
    } catch (_) {}
  }

  void updateLanguage(String language) {
    state = language;
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, String>(
  LanguageNotifier.new,
);
