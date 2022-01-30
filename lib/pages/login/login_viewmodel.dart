import 'dart:developer';

import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/services/api/api.dart';
import 'package:saise_de_temps/services/api/server_api.dart';
import 'package:stacked/stacked.dart';

class LoginVM extends BaseViewModel {
  Future<void> login(String email, String password) async {
    Future<void> _login() async {
      try{
        await API.api.login(username: email, password: password);
      } catch (e) {
        setError('Could not login.');
        log(e.toString());
      }
    }

    await runBusyFuture(_login());
  }
}