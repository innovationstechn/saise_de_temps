import 'package:saise_de_temps/models/credidentals_model.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/services/api/server_api.dart';

abstract class API {
  static final api = ServerAPI();
  Future<String> login({required CredentialsModel credentials});
  Future<void> submit({required List<Map> data});
  Future<List<FormElementModel>> getConfig();
}