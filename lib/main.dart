import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saise_de_temps/constants/globals.dart';
import 'package:saise_de_temps/models/form_element_model.dart';
import 'package:saise_de_temps/pages/form/form_view.dart';
import 'package:saise_de_temps/pages/login/login_view.dart';
import 'package:saise_de_temps/services/api/api.dart';
import 'package:saise_de_temps/services/database/db.dart';
import 'package:saise_de_temps/services/database/hive_db.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();

  runApp(
    const MyApp(),
  );
}

Future<void> initialize() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(FormElementModelAdapter());
  await HiveDB.initializeDB();

  final ip = await DB.db.getIPAddress();

  if (ip != null) {
    API.api.apiAddress = '$API_DEFAULT_ADDRESS';
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        scaffoldMessengerKey: snackbarKey,
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginView(),
          '/form': (context) => FormView(),
        },
      );
    });
  }
}
