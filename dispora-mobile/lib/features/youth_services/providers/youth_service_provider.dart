import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/youth_service.dart';
import '../repositories/youth_service_repository.dart';

final youthServiceRepositoryProvider = Provider<YouthServiceRepository>((ref) {
  return YouthServiceRepository();
});

final youthServiceListProvider = FutureProvider<List<YouthService>>((ref) async {
  final repository = ref.watch(youthServiceRepositoryProvider);
  return repository.getYouthServices();
});
