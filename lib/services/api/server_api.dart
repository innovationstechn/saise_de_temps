import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:saise_de_temps/constants/globals.dart';
import 'package:saise_de_temps/models/credidentals_model.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/services/api/api.dart';
import 'package:saise_de_temps/services/api/exceptions.dart';
import 'package:saise_de_temps/services/database/db.dart';

class ServerAPI implements API {
  late final BaseOptions _options;
  Dio? _dio;

  ServerAPI(String ip) {
    _options = BaseOptions(
      baseUrl: ip,
      connectTimeout: API_TIMEOUT_DURATION.inMilliseconds,
      receiveTimeout: API_TIMEOUT_DURATION.inMilliseconds,
      sendTimeout: API_TIMEOUT_DURATION.inMilliseconds,
    );

    _dio = Dio(_options);
  }

  String? token;

  String _base64Encode(String input) {
    final bytes = utf8.encode(input);
    return base64.encode(bytes);
  }

  @override
  Future<String> login({required CredentialsModel credentials}) async {
    Future<String> _login(String username, String password) async {
      try {
        final response = await _dio!.get(
          '/login',
          options: Options(
            headers: {
              'Authorization': 'Basic ${_base64Encode("$username:$password")}'
            },
          ),
        );

        return response.data['token'];
      } on DioError catch (e) {
        if (e.response?.statusCode == 401) {
          throw UnauthorisedException(
              'Unable to log in. Please check your username or password.');
        } else {
          throw RequestFailureException(
              "Sorry, we could not connect with the server. Either that address is invalid, or internet service is unavailable.");
        }
      }
    }

    token = await _login(credentials.name, credentials.password);

    return token!;
  }

  @override
  Future<List<FormElementModel>> getConfig() async {
    try {
      final response = await _dio!.get(
        '/get_config',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      List<FormElementModel> formElements = response.data['data']
          .map((e) => FormElementModel.fromJson(e))
          .toList()
          .cast<FormElementModel>();

      await DB.db.saveConfigData(formElements);
      await DB.db.saveLastConfigFetchTime(DateTime.now());

      return formElements;
    } on DioError {
      final cached = await DB.db.getConfigData();

      if (cached != null) {
        return cached;
      }

      throw RequestFailureException(
          'Sorry, we could not connect with the server.');
    }
  }

  @override
  Future<void> submit({required List<Map> data}) async {
    final responses = data.map((e) => e.values.toList().cast<Map>()).toList();

    try {
      await _dio!.post(
        '/submit',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: responses,
      );
    } on DioError catch (e) {
      throw RequestFailureException(
          'Sorry, we could not connect with the server.');
    }
  }

  @override
  Future<bool> checkConnectionToAPI() async {
    try {
      await _dio!.get(
        '/get_config',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  set apiAddress(String apiAddress) {
    _options.baseUrl = 'http://$apiAddress';
    _dio = Dio(_options);
  }
}
