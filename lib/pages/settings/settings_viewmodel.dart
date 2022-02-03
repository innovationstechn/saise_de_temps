import 'package:intl/intl.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:saise_de_temps/constants/globals.dart';
import 'package:saise_de_temps/services/api/api.dart';
import 'package:saise_de_temps/services/database/db.dart';
import 'package:saise_de_temps/utils/utils.dart';
import 'package:stacked/stacked.dart';

class SettingsVM extends BaseViewModel {
  String? _username;

  String? get username => _username;

  String? _connectionStatus;

  String? get connectionStatus => _connectionStatus;

  String? _configDate;

  String? get configDate => _configDate;

  int? _stagedResponsesCount;

  int? get stagedResponsesCount => _stagedResponsesCount;

  String? _ip;
  String? get ip => _ip;

  String? _port;
  String? get port => _port;

  Future<void> init() async {
    Future<void> _init() async {
      try {
        final credentials = await DB.db.getAuthCredentials();

        _username = credentials?.name;
      } catch (e) {
        _username = "Not available";
      }

      final isConnected = await API.api.checkConnectionToAPI();

      if (isConnected) {
        _connectionStatus = "Connected";
      } else {
        _connectionStatus = "Not Connected";
      }

      try {
        final configData = await DB.db.getLastConfigFetchTime();
        final dateFormat = DateFormat().add_yMd().add_jm();

        if (configData != null) {
          _configDate = dateFormat.format(configData);
        } else {
          _configDate = "Not available";
        }
      } catch (e) {
        _configDate = "Not available";
      }

      try {
        _stagedResponsesCount = await DB.db.countForms();
      } catch (e) {
        _stagedResponsesCount = 0;
      }
    }

    final address = await DB.db.getIPAddress();

    if(address != null) {
      _ip = address.split(':').first;
      _port = address.split(':').last;
    } else {
      _ip = API_DEFAULT_ADDRESS.split(':').first;
      _port = API_DEFAULT_ADDRESS.split(':').last;
    }

    await runBusyFuture(_init());
  }

  void onOKTapped(String ip, String port) {
    if(!validator.ip(ip)) {
      Utils.showSnackbar('IP is invalid.');
    } else {
      DB.db.saveIPAddress('$ip:$port');

      API.api.apiAddress = '$ip:$port';

      navigatorKey.currentState!.pop();
    }
  }
}
