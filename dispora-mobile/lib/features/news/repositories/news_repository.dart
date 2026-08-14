import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/news.dart';

class NewsRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<News>> getNews() async {
    try {
      final response = await _apiClient.dio.get('/news');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => News.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load news: ${e.message}');
    }
  }
}
