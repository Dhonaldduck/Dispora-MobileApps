import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  /// Register User
  Future<void> register(String fullName, String email, String phoneNumber, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: {
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal melakukan pendaftaran');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan saat pendaftaran');
    }
  }

  /// Login User
  /// Returns the JWT access token if successful.
  Future<String> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['access_token'];
      } else {
        throw Exception('Email atau password salah');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login gagal');
    }
  }

  /// Admin Login
  /// Returns the JWT access token if successful.
  Future<String> loginAdmin(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/admin/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['access_token'];
      } else {
        throw Exception('Email atau password salah');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login admin gagal');
    }
  }
}
