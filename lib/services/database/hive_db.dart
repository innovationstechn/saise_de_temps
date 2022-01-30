import 'package:hive/hive.dart';
import 'package:saise_de_temps/services/database/db.dart';

class HiveDB implements DB{

  var box;
  Map<String, dynamic> map = {};

  @override
  Future<bool?> initializeDB()async{
    box = await Hive.openBox('forms');
    return true;
  }

  @override
  Future<bool?> addForm() async {
    if(box==null) {
      await initializeDB();
    }
    box.add(map);
    await getForms();
    map.clear();
    return true;
  }

  @override
  Future<bool?> getForms() async {
    List<Map> forms =  box.values.toList().cast<Map>();
    print(forms.toString());
  }

  @override
  void saveField(int? id, String? field) {
    map[id.toString()] = field;
  }
}