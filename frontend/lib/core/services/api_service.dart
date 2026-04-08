import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api/v1';
  
  late Dio _dio;
  late SharedPreferences _prefs;
  String? _token;

  ApiService() {
    _initDio();
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptor for token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          print('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString('jwt_token');
  }

  // ============ AUTHENTICATION ============

  /// Register new user
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    String role = 'FARMER',
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      
      // Save token
      if (data['success'] == true && data['data'] != null) {
        final token = data['data']['token'];
        _token = token;
        await _prefs.setString('jwt_token', token);
        
        // Also save user data
        final user = data['data']['user'];
        await _prefs.setString('user_id', user['id']);
        await _prefs.setString('user_email', user['email']);
        await _prefs.setString('user_role', user['role']);
      }

      return data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/auth/profile');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? location,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (phone != null) data['phone'] = phone;
      if (location != null) data['location'] = location;
      if (latitude != null) data['latitude'] = latitude;
      if (longitude != null) data['longitude'] = longitude;

      final response = await _dio.put('/auth/profile', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Change password
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get user preferences
  Future<Map<String, dynamic>> getPreferences() async {
    try {
      final response = await _dio.get('/auth/preferences');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update user preferences
  Future<Map<String, dynamic>> updatePreferences({
    bool? weatherAlerts,
    bool? diseaseAlerts,
    bool? priceAlerts,
    bool? recommendationAlerts,
    String? language,
    String? theme,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (weatherAlerts != null) data['weatherAlerts'] = weatherAlerts;
      if (diseaseAlerts != null) data['diseaseAlerts'] = diseaseAlerts;
      if (priceAlerts != null) data['priceAlerts'] = priceAlerts;
      if (recommendationAlerts != null) {
        data['recommendationAlerts'] = recommendationAlerts;
      }
      if (language != null) data['language'] = language;
      if (theme != null) data['theme'] = theme;

      final response = await _dio.put('/auth/preferences', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============ FARMS ============

  /// Create a new farm
  Future<Map<String, dynamic>> createFarm({
    required String name,
    String? description,
    required double totalArea,
    String? soilType,
    String? location,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await _dio.post(
        '/farms',
        data: {
          'name': name,
          'description': description,
          'totalArea': totalArea,
          'soilType': soilType,
          'location': location,
          'latitude': latitude,
          'longitude': longitude,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all user farms
  Future<Map<String, dynamic>> getFarms() async {
    try {
      final response = await _dio.get('/farms');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get farm by ID
  Future<Map<String, dynamic>> getFarmById(String farmId) async {
    try {
      final response = await _dio.get('/farms/$farmId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update farm
  Future<Map<String, dynamic>> updateFarm({
    required String farmId,
    String? name,
    String? description,
    double? totalArea,
    String? soilType,
    String? location,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (totalArea != null) data['totalArea'] = totalArea;
      if (soilType != null) data['soilType'] = soilType;
      if (location != null) data['location'] = location;
      if (latitude != null) data['latitude'] = latitude;
      if (longitude != null) data['longitude'] = longitude;

      final response = await _dio.put('/farms/$farmId', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete farm
  Future<Map<String, dynamic>> deleteFarm(String farmId) async {
    try {
      final response = await _dio.delete('/farms/$farmId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ============ LOCAL STORAGE ============

  /// Check if user is logged in
  bool isLoggedIn() => _token != null;

  /// Get stored user ID
  String? getUserId() => _prefs.getString('user_id');

  /// Get stored user email
  String? getUserEmail() => _prefs.getString('user_email');

  /// Get stored user role
  String? getUserRole() => _prefs.getString('user_role');

  /// Logout and clear token
  Future<void> logout() async {
    _token = null;
    await _prefs.remove('jwt_token');
    await _prefs.remove('user_id');
    await _prefs.remove('user_email');
    await _prefs.remove('user_role');
  }

  // ============ ERROR HANDLING ============

  String _handleError(DioException error) {
    String message = 'An error occurred';

    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data['message'] != null) {
        message = data['message'];
      } else {
        message = 'Error: ${error.response!.statusCode}';
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      message = 'Request timeout. Please try again.';
    } else {
      message = error.message ?? 'Unknown error occurred';
    }

    return message;
  }
}
