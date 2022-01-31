import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saise_de_temps/pages/form/form_page.dart';
import 'package:saise_de_temps/pages/login/login.dart';
import 'package:saise_de_temps/services/database/hive_db.dart';
import 'package:sizer/sizer.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await HiveDB.initializeDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/login',
            routes: {
              '/login': (context) => Login(),
              '/form': (context) => FormPage(),
            },
          );
        }
    );
  }
}