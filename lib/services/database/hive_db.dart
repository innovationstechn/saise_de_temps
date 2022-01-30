import 'package:hive/hive.dart';

class HiveDB {

  Future<bool?> addForm(Map item) async {
    var box = await Hive.openBox('forms');
    box.add(item);
    await getForms(box);
    box.close();
    return true;
  }

  Future<bool?> getForms(var box) async {
    List<Map> forms =  box.values.toList().cast<Map>();
    print(forms.toString());
  }

}