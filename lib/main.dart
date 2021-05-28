import 'package:flutter/material.dart';
import 'package:study_buddy/screens/store_inventory.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'study buddy',
        theme: ThemeData(primaryColor: Colors.white),
        home: StoreInventory(),

      // routes: {
        //   "/": (context) => HomePage(),
        //   "/user": (context) => UserPage(),
        //   "/main": (context) => MainFocus(),
        // }
    );
  }
}