import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:saise_de_temps/constants/globals.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/pages/settings/settings_view.dart';
import 'package:saise_de_temps/services/api/api.dart';
import 'package:saise_de_temps/services/api/exceptions.dart';
import 'package:saise_de_temps/services/database/db.dart';
import 'package:saise_de_temps/services/database/hive_db.dart';
import 'package:saise_de_temps/utils/utils.dart';
import 'package:stacked/stacked.dart';

class FormPageVM extends BaseViewModel {
  List<FormElementModel> _questions = [];

  List<FormElementModel> get questions => _questions;

  Future<void> loadData() async {
    Future<void> _loadData() async {
      try {
        clearErrors();

        _questions = await API.api.getConfig();
      } on CustomException catch (e) {
        Utils.showSnackbar(e.toString());
      } catch (e) {
        Utils.showSnackbar('Error while loading data.');
        setError('Error while loading data.');
        log(e.toString());
      }
    }

    await runBusyFuture(_loadData());
  }

  Future<void> submit(List<Map> data) async {
    Future<dynamic> _store() async {
      return await DB.db.addUserResponse();
    }

    Future<void> _submit() async {
      return await API.api.submit(data: [HiveDB.map]);
    }

    Future<dynamic> _clear() async {
      return await DB.db.clearUserResponses();
    }

    await runBusyFuture(() async {
      try {
        await _store();
        await _submit();
        await _clear();
      } on CustomException catch (e) {
        Utils.showSnackbar(
          e.toString(),
        );
        log(e.toString());
      } catch (e) {
        setError('Error while loading data.');
        log(e.toString());
      } finally {
        notifyListeners();
      }
    }());
  }

  Future<void> resync() async {
    Future<void> _resync() async {
      try {
        final maps = await DB.db.getUserResponses();

        await API.api.submit(data: maps);
      } catch (e) {
        Utils.showSnackbar(e.toString());
      }
    }

    await runBusyFuture(
      _resync(),
    );
  }

  Future onSettingsPressed() async {
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => const SettingsView(),
    );

    loadData();
  }
}
