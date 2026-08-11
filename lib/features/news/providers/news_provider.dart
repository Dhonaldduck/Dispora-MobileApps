import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news.dart';
import '../repositories/news_repository.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository();
});

final newsListProvider = FutureProvider<List<News>>((ref) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.getNews();
});
