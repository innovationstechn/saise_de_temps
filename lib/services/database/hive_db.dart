import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:saise_de_temps/models/credidentals_model.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/services/database/db.dart';

class HiveDB implements DB {
  static Box? _formsBox, _credentialsBox, _formConfigBox, _ipBox;
  static Map map = {};

  static Future initializeDB() async {
    _formsBox = await Hive.openBox('forms');
    _credentialsBox = await Hive.openBox('credentials');
    _formConfigBox = await Hive.openBox('formConfig');
    _ipBox = await Hive.openBox('ipBox');

    final items = _formsBox!.values.toList().cast<Map>();

    if (items.isNotEmpty) map = items.first;
  }

  @override
  Future clearUserResponses() async {
    _formsBox!.clear();
  }

  @override
  Future<bool?> addUserResponse() async {
    Map<String, dynamic> responses = {};

    _formsBox!.add(
      map,
    );

    return true;
  }

  @override
  Future<List<Map>> getUserResponses() async {
    return Future.delayed(
      Duration.zero,
      () => _formsBox!.values.toList().cast<Map>(),
    );
  }

  @override
  Future<int> countForms() async {
    return _formsBox!.values.length;
  }

  @override
  void saveField(int? id, String? field) {
    // map[id.toString()] = field;
    map[id.toString()] = {
      'id': id,
      'reply': field,
    };
  }

  @override
  Future<void> saveAuthCredentials(CredentialsModel credentials) async {
    _credentialsBox!.put('credentials', credentials.toJson());
  }

  @override
  Future<CredentialsModel?> getAuthCredentials() async {
    return CredentialsModel.fromJson(
      Map<String, dynamic>.from(
        _credentialsBox!.get('credentials'),
      ),
    );
  }

  @override
  Future saveConfigData(List<FormElementModel> formElements) async {
    await _formConfigBox!.put('config', formElements);
  }

  @override
  Future<List<FormElementModel>?> getConfigData() async {
    final config = _formConfigBox!.get('config');

    return await Future.delayed(
      Duration.zero,
      () => config,
    );
  }

  @override
  Future<DateTime?> getLastConfigFetchTime() async {
    final configTime = _formConfigBox!.get('timestamp');

    if (configTime != null) {
      return await Future.delayed(
        Duration.zero,
        () => DateTime.parse(
          configTime,
        ),
      );
    }
  }

  @override
  Future<void> saveLastConfigFetchTime(DateTime timestamp) async {
    await _formConfigBox!.put('timestamp', timestamp.toIso8601String());
  }

  @override
  Future<String?> getIPAddress() {
    return Future.delayed(
      Duration.zero,
      () => _ipBox!.get('ip'),
    );
  }

  @override
  Future<void> saveIPAddress(String address) async {
    await _ipBox!.put('ip', address);
  }
}
