import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saise_de_temps/pages/form/form_page.dart';
import 'package:saise_de_temps/pages/login/login.dart';
import 'package:saise_de_temps/services/api/api.dart';
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
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => Login(),
              '/login': (context) => Login(),
              '/form': (context) => FormPage(),
            },
          );
        }
    );
  }
}