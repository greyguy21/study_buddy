import 'package:flutter/material.dart';

class SetUp extends StatefulWidget {
  @override
  _SetUpState createState() => _SetUpState();
}

class _SetUpState extends State<SetUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50.0),
          color: Colors.lightBlue,
          child: Text(
            "Let's Set up!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 21.0,
            )
          )
        ),
      ),
    );
  }
}
