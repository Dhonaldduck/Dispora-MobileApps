import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  /// Request OTP for User Login
  Future<void> requestOtp(String phoneNumber) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/otp/request',
        data: {'phone': phoneNumber},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal meminta OTP');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }

  /// Verify OTP for User Login
  /// Returns the JWT access token if successful.
  Future<String> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/otp/verify',
        data: {
          'phone': phoneNumber,
          'otp': otp,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['access_token'];
      } else {
        throw Exception('OTP tidak valid');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          'Terjadi kesalahan saat verifikasi OTP');
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
