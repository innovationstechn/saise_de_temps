import 'package:hive/hive.dart';
import 'package:saise_de_temps/models/credidentals_model.dart';
import 'package:saise_de_temps/services/database/db.dart';

class HiveDB implements DB {
  static Box? _formsBox, _credentialsBox;
  static Map map = {};

  static Future initializeDB() async {
    _formsBox = await Hive.openBox('forms');
    _credentialsBox = await Hive.openBox('credentials');

    final items = _formsBox!.values.toList().cast<Map>();

    if (items.isNotEmpty) map = items.first;
  }

  @override
  Future clear() async {
    _formsBox!.clear();
  }

  @override
  Future<bool?> addForm() async {
    _formsBox!.add(map);
    return true;
  }

  @override
  Future<bool> hasForms() async {
    List<Map> forms = _formsBox!.values.toList().cast<Map>();

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

  @override
  Future<void> saveCredentials(CredentialsModel credentials) async {
    _credentialsBox!.put('credentials', credentials.toJson());
  }

  @override
  Future<CredentialsModel?> getCredentials() async {
    return CredentialsModel.fromJson(
      Map<String, dynamic>.from(
        _credentialsBox!.get('credentials'),
      ),
    );
  }
}
