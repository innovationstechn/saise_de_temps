import 'dart:developer';

import 'package:saise_de_temps/models/credidentals_model.dart';
import 'package:saise_de_temps/services/api/api.dart';
import 'package:saise_de_temps/services/database/db.dart';
import 'package:stacked/stacked.dart';

class LoginVM extends BaseViewModel {
  CredentialsModel? _credentials;
  CredentialsModel? get credentials => _credentials;

  Future<void> loadPreviousCredentials() async {
    Future<void> _load() async {
      try {
        _credentials = await DB.db.getCredentials();
      } catch(e) {
        setError('Could not load previous credentials.');
        log(e.toString());
      }
    }

    runBusyFuture(_load());
  }

  Future<void> login(String email, String password) async {
    Future<void> _login() async {
      try{
        clearErrors();

        final credentials = CredentialsModel(name: email, password: password);

        await API.api.login(credentials: credentials);
        await DB.db.saveCredentials(credentials);
      } catch (e) {
        setError('Could not login.');
        log(e.toString());
      }
    }

    await runBusyFuture(_login());
  }
}