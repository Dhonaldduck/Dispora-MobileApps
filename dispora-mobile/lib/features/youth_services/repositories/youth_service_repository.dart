import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/youth_service.dart';

class YouthServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<YouthService>> getYouthServices() async {
    try {
      final response = await _apiClient.dio.get('/youth-services');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => YouthService.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load youth services');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load youth services: ${e.message}');
    }
  }
}
