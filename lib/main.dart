import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/screens/homepage.dart';
import 'package:study_buddy/screens/items_page.dart';
import 'package:study_buddy/screens/main_focus.dart';
// import 'package:study_buddy/screens/ .dart';
import 'package:study_buddy/screens/authentication.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/screens/menu.dart';
import 'package:study_buddy/screens/settings.dart';
import 'package:study_buddy/screens/setup.dart';
import 'package:study_buddy/screens/store_inventory.dart';
// import 'package:study_buddy/screens/menu.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'study buddy',
        theme: ThemeData(primaryColor: Colors.white),
        initialRoute: "/authenticate",
        // home: Authentication(),

        routes: {
          "/": (context) => HomePage(),
          "/authenticate": (context) => Authentication(),
          "/setup": (context) => SetUp(),
          "/menu": (context) => Menu(),
          "/settings": (context) => SettingsPage(),
        });
  }
}
