import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/custom_timer.dart';
import '../globals.dart' as globals;

// this page only has the background wallpaper, animal & items,
// animal speech box, timer

class MainFocusPage extends StatefulWidget {
  @override
  _MainFocusPageState createState() => _MainFocusPageState();
}

class _MainFocusPageState extends State<MainFocusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage('assets/defaultBg.jpeg'),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            margin: EdgeInsets.only(top: 108),
            child: Column(children: <Widget>[
              // add animal and items here
              Container(
                margin: EdgeInsets.only(
                  top: 350,
                ),
                child: Image(
                  image: AssetImage('assets/dog.jpg'),
                ),
              ),
              // timer widget
              Container(
                margin: EdgeInsets.only(top: 50),
                child: CustomTimer(),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
