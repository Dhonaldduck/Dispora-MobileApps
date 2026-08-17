import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/agenda_model.dart';
import '../repositories/agenda_repository.dart';

final agendaRepositoryProvider = Provider<AgendaRepository>((ref) {
  return AgendaRepository();
});

final agendaProvider = FutureProvider<List<AgendaModel>>((ref) async {
  final repository = ref.watch(agendaRepositoryProvider);
  return repository.getAgendas();
});
