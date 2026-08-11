import 'dart:io';
import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    // 10.0.2.2 is for Android Emulator to connect to host localhost
    // 127.0.0.1 is for iOS Simulator
    String baseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:3000',
    );

    if (Platform.isIOS) {
       baseUrl = const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://127.0.0.1:3000',
      );
    }

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Optional: Add Interceptors for logging or auth token
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }
}
