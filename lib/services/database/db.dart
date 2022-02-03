import 'package:saise_de_temps/models/credidentals_model.dart';
import 'package:saise_de_temps/models/form_element_model.dart';

import 'hive_db.dart';

abstract class DB {
  static final db = HiveDB();

  Future<bool?> addUserResponse();
  Future<List<Map>> getUserResponses();
  Future clearUserResponses();

  Future<int> countForms();

  Future<void> saveConfigData(List<FormElementModel> formsElements);
  Future<List<FormElementModel>?> getConfigData();

  Future<void> saveLastConfigFetchTime(DateTime timestamp);
  Future<DateTime?> getLastConfigFetchTime();

  Future<void> saveIPAddress(String address);
  Future<String?> getIPAddress();

  void saveField(int? id, String? field);

  Future<void> saveAuthCredentials(CredentialsModel credentials);
  Future<CredentialsModel?> getAuthCredentials();
}
