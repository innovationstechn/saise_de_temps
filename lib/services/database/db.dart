import 'package:hive/hive.dart';

import 'hive_db.dart';

abstract class DB {
  static final db = HiveDB();
  Future<bool?> addForm();
  Future<bool?> hasForms();
  Future clear();
  void saveField(int? id,String? field);
}