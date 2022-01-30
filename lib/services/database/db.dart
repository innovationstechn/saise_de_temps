import 'package:hive/hive.dart';

import 'hive_db.dart';

abstract class DB {
  static final db = HiveDB();
  Future<bool?> initializeDB();
  Future<bool?> addForm();
  Future<bool?> getForms();
  void saveField(int? id,String? field);
}