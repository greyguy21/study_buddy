import 'package:flutter/material.dart';
import 'package:study_buddy/screens/homepage.dart';
import 'package:study_buddy/screens/main_focus.dart';
// import 'package:study_buddy/screens/ .dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'study buddy',
      theme: ThemeData(primaryColor: Colors.white),
      home: HomePage(),
      initialRoute: "/",
      // routes: {
      //   "/": (context) => HomePage(),
      //   "/user": (context) => UserPage(),
      //   "/main": (context) => MainFocus(),
      // }
    );
  }
}
