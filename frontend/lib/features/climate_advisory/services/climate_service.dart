import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_service.dart';
import '../models/climate_model.dart';
import 'package:geolocator/geolocator.dart';

class ClimateService {
  final String _baseUrl = '${ApiService.baseUrl}/climate';

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  Map<String, String> _getHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition();
  }

  Future<ClimateAdvisoryResponse> fetchClimateAdvisory() async {
    try {
      // 1. Fetch GPS location coordinates
      final position = await _determinePosition();
      
      final token = await _getToken();
      final url = '$_baseUrl/advisory?lat=${position.latitude}&lon=${position.longitude}';

      // 2. Fetch Data from our Node Backend (which wraps weather logic + risk analysis)
      final response = await http.get(Uri.parse(url), headers: _getHeaders(token));
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return ClimateAdvisoryResponse.fromJson(decoded['data']);
      } else {
        throw Exception('Failed to load climate advisory. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching climate data: $e');
    }
  }
}
