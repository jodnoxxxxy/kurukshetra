import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/features/auth/services/firebase_user_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? token;

  AuthState({this.status = AuthStatus.unknown, this.token});
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkStatus();
    return AuthState(status: AuthStatus.unknown);
  }

  Future<void> _checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null) {
      state = AuthState(status: AuthStatus.authenticated, token: token);
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    state = AuthState(status: AuthStatus.authenticated, token: token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

// Firebase User Service Provider
final firebaseUserServiceProvider = Provider((ref) {
  return FirebaseUserService();
});
