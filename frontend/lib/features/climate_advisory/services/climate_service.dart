import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_service.dart';
import '../models/climate_model.dart';
import 'package:geolocator/geolocator.dart';

class ClimateService {
  final String _baseUrl = '${ApiService.baseUrl}/climate';
  final String _cacheKey = 'cached_climate_advisory';
  final Duration _cacheDuration = const Duration(minutes: 15);

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
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable location services in settings.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied by user.');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied. Please enable in app settings.');
      } 

      // Set timeout for GPS location lock
      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 30),
      );
      
      return position;
    } catch (e) {
      throw ClimateException(
        code: 'LOCATION_ERROR',
        message: 'Failed to get location: $e'
      );
    }
  }

  // OFFLINE CACHING SUPPORT
  Future<void> _cacheAdvisory(ClimateAdvisoryResponse data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(data.toJson());
      await prefs.setString(_cacheKey, jsonString);
      await prefs.setString('${_cacheKey}_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      print('Error caching advisory: $e');
    }
  }

  Future<ClimateAdvisoryResponse?> _getCachedAdvisory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      final timestamp = prefs.getString('${_cacheKey}_timestamp');
      
      if (cachedData == null || timestamp == null) {
        return null;
      }

      // Check if cache is still valid
      final cacheTime = DateTime.parse(timestamp);
      if (DateTime.now().difference(cacheTime) > _cacheDuration) {
        return null; // Cache expired
      }

      final decoded = jsonDecode(cachedData);
      return ClimateAdvisoryResponse.fromJson(decoded);
    } catch (e) {
      print('Error retrieving cached advisory: $e');
      return null;
    }
  }

  Future<ClimateAdvisoryResponse> fetchClimateAdvisory() async {
    try {
      // STEP 1: Try to get location
      final position = await _determinePosition();
      final lat = position.latitude;
      final lon = position.longitude;
      
      final token = await _getToken();
      
      // STEP 2: Try to fetch fresh data
      try {
        final url = '$_baseUrl/advisory?lat=$lat&lon=$lon';
        final response = await http.get(
          Uri.parse(url),
          headers: _getHeaders(token),
        ).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw ClimateException(
            code: 'NETWORK_TIMEOUT',
            message: 'Request timed out. Using cached data if available.'
          )
        );
        
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final advisory = ClimateAdvisoryResponse.fromJson(decoded['data']);
          
          // Cache the successful response
          await _cacheAdvisory(advisory);
          
          return advisory;
        } else if (response.statusCode == 400) {
          throw ClimateException(
            code: 'INVALID_LOCATION',
            message: 'Invalid geolocation coordinates provided.'
          );
        } else if (response.statusCode == 503) {
          throw ClimateException(
            code: 'SERVICE_UNAVAILABLE',
            message: 'Weather service temporarily unavailable. Using cached data.'
          );
        } else {
          throw ClimateException(
            code: 'HTTP_ERROR',
            message: 'Failed to load climate advisory. Status: ${response.statusCode}'
          );
        }
      } catch (networkError) {
        print('Network error: $networkError');
        
        // STEP 3: If network fails, try to use cached data
        final cachedAdvisory = await _getCachedAdvisory();
        if (cachedAdvisory != null) {
          print('Using cached climate data');
          return cachedAdvisory;
        }
        
        // STEP 4: If no cache, rethrow the error
        rethrow;
      }
    } on ClimateException {
      rethrow;
    } catch (e) {
      throw ClimateException(
        code: 'UNKNOWN_ERROR',
        message: 'Error fetching climate data: $e'
      );
    }
  }
}

// Custom exception for better error handling
class ClimateException implements Exception {
  final String code;
  final String message;

  ClimateException({required this.code, required this.message});

  @override
  String toString() => message;
}
