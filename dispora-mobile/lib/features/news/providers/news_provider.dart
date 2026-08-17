import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_model.dart';

class NewsRepository {
  final Dio _dio;

  NewsRepository()
      : _dio = Dio(BaseOptions(
          baseUrl: 'http://10.0.2.2:3000',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  Future<List<NewsModel>> getLatestNews() async {
    try {
      final response = await _dio.get('/news');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => NewsModel.fromJson(json)).toList();
      }
      throw Exception('Gagal memuat berita: ${response.statusCode}');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository();
});

final latestNewsProvider = FutureProvider<List<NewsModel>>((ref) async {
  final repository = ref.read(newsRepositoryProvider);
  return repository.getLatestNews();
});
