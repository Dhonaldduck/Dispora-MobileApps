import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/agenda.dart';
import '../repositories/agenda_repository.dart';

final agendaRepositoryProvider = Provider<AgendaRepository>((ref) {
  return AgendaRepository();
});

final agendaListProvider = FutureProvider<List<Agenda>>((ref) async {
  final repository = ref.watch(agendaRepositoryProvider);
  return repository.getAgendas();
});
