import 'dart:developer';

import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/services/api/api.dart';
import 'package:saise_de_temps/services/api/server_api.dart';
import 'package:saise_de_temps/services/database/db.dart';
import 'package:saise_de_temps/services/database/hive_db.dart';
import 'package:stacked/stacked.dart';

class FormPageVM extends BaseViewModel {
  List<FormElementModel> _questions = [];
  List<FormElementModel> get questions => _questions;

  Future<bool> get hasForms async => DB.db.hasForms();

  Future<void> loadData() async {
    Future<void> _loadData() async {
      try{
        _questions = await API.api.getConfig();
      } catch (e) {
        setError('Error while loading data.');
        log(e.toString());
      }
    }

    await runBusyFuture(_loadData());
  }

  Future<void> submit(Map data) async{
    Future<dynamic> _store() async{
      return await DB.db.addForm();
    }

    Future<void> _submit() async{
      return await API.api.submit(data: HiveDB.map.values.toList().cast<Map>());
    }

    Future<dynamic> _clear() async{
      return await DB.db.clear();
    }

    await runBusyFuture(() async {
      try{
        await _store();
        await _submit();
        await _clear();
      } catch(e) {
        setError('Could not save data.');
        log(e.toString());
      }
    } ());
  }
}