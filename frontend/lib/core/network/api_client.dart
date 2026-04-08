import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  late Dio _dio;

  ApiClient._internal() {
    // Determine the host depending on the platform
    // 10.0.2.2 is the localhost alias for Android Emulator
    // For iOS emulator or Web, localhost or 127.0.0.1 is fine
    String baseUrl = const String.fromEnvironment('API_URL', defaultValue: 'http://localhost:5000/api/v1');
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
       baseUrl = 'http://10.0.2.2:5000/api/v1';
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logging interceptor for debugging network requests
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: kDebugMode,
      responseHeader: false,
      responseBody: kDebugMode,
      error: true,
    ));
  }

  Dio get dio => _dio;
  
  // Future enhancements: Add method to inject Auth Token via interceptor
}
