import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  initial,
  unauthenticated,
  loading,
  authenticated,
}

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? token;

  AuthState({
    required this.status,
    this.errorMessage,
    this.token,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? token,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  static const String _tokenKey = 'jwt_token';

  AuthNotifier(this._authService) : super(AuthState(status: AuthStatus.initial)) {
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token != null && token.isNotEmpty) {
        state = state.copyWith(status: AuthStatus.authenticated, token: token);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> loginAdmin(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final token = await _authService.loginAdmin(email, password);
      await _storage.write(key: _tokenKey, value: token);
      state = state.copyWith(status: AuthStatus.authenticated, token: token);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> requestOtp(String phoneNumber) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.requestOtp(phoneNumber);
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final token = await _authService.verifyOtp(phoneNumber, otp);
      await _storage.write(key: _tokenKey, value: token);
      state = state.copyWith(status: AuthStatus.authenticated, token: token);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    await _storage.delete(key: _tokenKey);
    state = state.copyWith(status: AuthStatus.unauthenticated, token: null);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});
