import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  initial,
  unauthenticated,
  guest,
  loading,
  authenticated,
}

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? token;
  final User? user;

  AuthState({
    required this.status,
    this.errorMessage,
    this.token,
    this.user,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isGuest => status == AuthStatus.guest;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? token,
  }) {
    User? parsedUser = this.user;
    if (token != null && token != this.token) {
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = json.decode(
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
          );
          parsedUser = User.fromJwt(payload);
        }
      } catch (e) {
        // Parse error, ignore and leave parsedUser as null or previous
      }
    } else if (token == null) {
      parsedUser = null;
    }

    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      token: token ?? this.token,
      user: parsedUser,
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
      // Hapus token untuk memaksa kembali ke halaman login (mode development)
      await _storage.delete(key: _tokenKey);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  void setGuestMode() {
    state = state.copyWith(status: AuthStatus.guest, token: null);
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final token = await _authService.login(email, password);
      await _storage.write(key: _tokenKey, value: token);
      state = state.copyWith(status: AuthStatus.authenticated, token: token);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register(String fullName, String email, String phoneNumber, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.register(fullName, email, phoneNumber, password);
      state = state.copyWith(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
      throw e; // Rethrow to handle it in the UI (e.g. stop loading, show error)
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
