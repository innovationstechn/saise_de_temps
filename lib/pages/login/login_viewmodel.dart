import 'dart:developer';

import 'package:saise_de_temps/constants/globals.dart';
import 'package:saise_de_temps/models/credidentals_model.dart';
import 'package:saise_de_temps/services/api/api.dart';
import 'package:saise_de_temps/services/api/exceptions.dart';
import 'package:saise_de_temps/services/database/db.dart';
import 'package:saise_de_temps/utils/utils.dart';
import 'package:stacked/stacked.dart';

class LoginVM extends BaseViewModel {
  CredentialsModel? _credentials;
  CredentialsModel? get credentials => _credentials;

  String? _ipAddress;
  String? get ipAddress => _ipAddress;

  Future<void> initialize() async {
    Future<void> _load() async {
      try {
        _credentials = await DB.db.getAuthCredentials();
        _ipAddress = await DB.db.getIPAddress() ?? API_DEFAULT_ADDRESS;
        _ipAddress = 'http://$_ipAddress/get_logo';
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
        await DB.db.saveAuthCredentials(credentials);

        Utils.navigateTo('/form');
      } on CustomException catch(e) {
        Utils.showSnackbar(e.toString());
      } catch (e) {
        Utils.showSnackbar('Sorry, we encountered an unknown error');
      }
    }

    await runBusyFuture(_login());
  }
}