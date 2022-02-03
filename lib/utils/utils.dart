import 'package:flutter/material.dart';
import 'package:saise_de_temps/constants/globals.dart';

class Utils {
  static void showSnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
    );

    snackbarKey.currentState?.showSnackBar(snackbar);
  }

  static Future navigateTo(String path) async {
    return navigatorKey.currentState?.pushNamed(path);
  }
}
