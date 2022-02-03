//globals.dart

import 'package:flutter/material.dart';

// For displaying snackbars without scaffolds and/or contexts.
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey();

// For navigating without contexts.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

// API configuration
const API_TIMEOUT_DURATION = Duration(seconds: 5);
const API_DEFAULT_ADDRESS = '135.125.206.72:5432';