import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/services/api/api.dart';

class ServerAPI implements API {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://135.125.206.72:5000'),
  );

  String? token;

  String _base64Encode(String input) {
    final bytes = utf8.encode(input);
    return base64.encode(bytes);
  }

  Future<void> initialize() async {
    token = await login(username: "argth", password: "pouet");
    print(token);
  }

  @override
  Future<String> login(
      {required String username, required String password}) async {
    try {
      final response = await _dio.get(
        '/login',
        options: Options(
          headers: {
            'Authorization': 'Basic ${_base64Encode("$username:$password")}'
          },
        ),
      );

      return response.data['token'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<FormElementModel>> getConfig() async {
    try {
      final response = await _dio.get(
        '/get_config',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.data['data']
          .map((e) => FormElementModel.fromJson(e))
          .toList()
          .cast<FormElementModel>();
    } catch (e) {
      rethrow;
    }
  }
}
