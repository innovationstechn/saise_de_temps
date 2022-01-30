import 'package:hive/hive.dart';
import 'package:saise_de_temps/services/database/db.dart';

class HiveDB implements DB {
  static Box? _box;
  static Map map = {};

  static Future initializeDB() async {
    _box = await Hive.openBox('forms');

    final items  = _box!.values.toList().cast<Map>();

    if(items.isNotEmpty) map = items.first;
  }

  Future clear() async {
    _box!.clear();
  }

  @override
  Future<bool?> addForm() async {
    _box!.add(map);
    return true;
  }

  @override
  Future<bool> hasForms() async {
    List<Map> forms = _box!.values.toList().cast<Map>();

    return forms.isNotEmpty;
  }

  @override
  void saveField(int? id, String? field) {
    // map[id.toString()] = field;
    map[id.toString()] = {
      'id': id,
      'reply': field,
    };
  }
}
