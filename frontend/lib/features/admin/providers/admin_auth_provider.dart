import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminState {
  final bool isAuthenticated;
  final String? adminId;
  final String? error;

  AdminState({this.isAuthenticated = false, this.adminId, this.error});

  AdminState copyWith({bool? isAuthenticated, String? adminId, String? error}) {
    return AdminState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      adminId: adminId ?? this.adminId,
      error: error,
    );
  }
}

class AdminAuthNotifier extends Notifier<AdminState> {
  @override
  AdminState build() => AdminState();

  Future<bool> login(String id, String password) async {
    // Simulated admin credentials
    if ((id == 'admin' && password == 'admin123') ||
        (id == 'shreyash' && password == '123456')) {
      state = state.copyWith(isAuthenticated: true, adminId: id, error: null);
      return true;
    } else {
      state = state.copyWith(isAuthenticated: false, error: 'Invalid credentials');
      return false;
    }
  }

  void logout() {
    state = AdminState();
  }
}

final adminAuthProvider = NotifierProvider<AdminAuthNotifier, AdminState>(AdminAuthNotifier.new);
