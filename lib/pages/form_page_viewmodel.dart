import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/services/api/server_api.dart';
import 'package:stacked/stacked.dart';

class FormPageVM extends BaseViewModel {
  List<FormElementModel> _questions = [];
  List<FormElementModel> get questions => _questions;

  Future<void> loadData() async {
    Future<void> _loadData() async {
      _questions = await ServerAPI.api.getConfig();
    }

    runBusyFuture(_loadData());
  }
}