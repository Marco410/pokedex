import 'package:dio/dio.dart';
import 'package:pokedex/core/constants.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: Constants.apiBaseUrl));

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: params);
      return response.data;
    } catch (e) {
      throw Exception("Error fetching data");
    }
  }
}
