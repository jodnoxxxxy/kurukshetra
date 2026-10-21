import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/core/services/api_service.dart';

class FirebaseUserService {
  final String _baseUrl = ApiService.baseUrl;

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  Future<void> saveFarmerRegistration({
    required String userId, required String firstName, required String lastName,
    required String email, required String phone, required String soilType,
    required String location, required double farmArea, required String taluka,
    required String district,
  }) async { return; }

  Future<Map<String, dynamic>?> getFarmerProfile(String userId) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/farmers/profile'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['data']['farmer'];
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch farmer profile: $e');
    }
  }

  Stream<Map<String, dynamic>?> streamFarmerProfile(String userId) async* {
    try {
      final profile = await getFarmerProfile(userId);
      yield profile;
    } catch (e) {
      yield null;
    }
  }

  Future<void> updateFarmerProfile(String userId, Map<String, dynamic> updates) async {
    try {
      final token = await _getToken();
      await http.put(Uri.parse('$_baseUrl/farmers/profile'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode(updates));
    } catch (e) { throw Exception('Failed to update farmer profile: $e'); }
  }

  Future<void> updateFarmerField(String userId, String fieldName, dynamic value) async {
    await updateFarmerProfile(userId, {fieldName: value});
  }

  Future<void> deleteFarmerProfile(String userId) async { return; }

  Future<bool> farmerExists(String userId) async {
    final profile = await getFarmerProfile(userId);
    return profile != null;
  }

  Future<List<Map<String, dynamic>>> getFarmerFarms(String userId) async {
    try {
      final token = await _getToken();
      final response = await http.get(Uri.parse('$_baseUrl/farmers/farms'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(decoded['data']['farms'] ?? []);
      }
      return [];
    } catch (e) { return []; }
  }

  Future<void> addFarmToFarmer(String userId, Map<String, dynamic> farmData) async { return; }
  Future<void> updateFarm(String userId, String farmId, Map<String, dynamic> updates) async { return; }
  String? getCurrentUserId() { return 'demo_farmer_123'; }
}
