import 'package:saise_de_temps/models/credidentals_model.dart';

import 'hive_db.dart';

abstract class DB {
  static final db = HiveDB();

  Future<bool?> addForm();

  Future<bool?> hasForms();

  Future clear();

  void saveField(int? id, String? field);

  Future<void> saveCredentials(CredentialsModel credentials);
  Future<CredentialsModel?> getCredentials();
}
