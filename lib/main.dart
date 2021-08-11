import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/custom_timer.dart';
import 'package:study_buddy/screens/homepage.dart';
import 'package:study_buddy/screens/statistics.dart';
import 'package:study_buddy/screens/main_focus.dart';
import 'package:study_buddy/screens/authenticate/authentication.dart';
import 'package:study_buddy/screens/menu.dart';
import 'package:study_buddy/screens/settings.dart';
import 'package:study_buddy/screens/setup.dart';
import 'package:study_buddy/screens/store/store_inventory.dart';
import 'package:study_buddy/screens/authenticate/verify.dart';
import 'package:study_buddy/screens/end_session.dart';
import 'package:study_buddy/screens/tags.dart';
import 'package:study_buddy/screens/timeline.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'study buddy',
        theme: ThemeData(primaryColor: Colors.white),
        initialRoute: "/authenticate",
        routes: {
          "/": (context) => HomePage(),
          "/authenticate": (context) => Authentication(),
          "/setup": (context) => SetUp(),
          "/menu": (context) => Menu(),
          "/settings": (context) => SettingsPage(),
          "/store": (context) => StoreInventory(),
          "/verify": (context) => Verify(),
          "/mainfocus": (context) => MainFocusPage(),
          "/endSession": (context) => EndSession(),
          "/timeline": (context) => Timeline(),
          "/statistics": (context) => StatisticsPage(),
          "/tags": (context) => TagsPage(),
        });
  }
}
