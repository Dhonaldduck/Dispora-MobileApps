import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/agenda_model.dart';

class AgendaRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<AgendaModel>> getAgendas() async {
    try {
      final response = await _apiClient.dio.get('/agendas');
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> listData = data is Map ? data['data'] : data;
        return listData.map((json) => AgendaModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load agendas');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load agendas: ${e.message}');
    }
  }
}
