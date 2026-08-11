import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/agenda.dart';

class AgendaRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Agenda>> getAgendas() async {
    try {
      final response = await _apiClient.dio.get('/agendas');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Agenda.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load agendas');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load agendas: ${e.message}');
    }
  }
}
