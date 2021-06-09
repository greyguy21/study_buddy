import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/custom_timer.dart';
import '../globals.dart' as globals;
import 'dart:async';

// this page only has the background wallpaper, animal & items,
// animal speech box, timer

class MainFocusPage extends StatefulWidget {
  @override
  _MainFocusPageState createState() => _MainFocusPageState();
}

class _MainFocusPageState extends State<MainFocusPage> {
  int _minutes = globals.timeSliderValue.round();
  int _seconds = 00;
  // var timeout = Duration(minutes: tasktime);

  void handleTimeout() {
    // add coins for successful focus session
    // add popup??
    Navigator.pushNamed(context, "/");
  }

  late Timer _timer;

  void _startTimer() {
    // Timer _timer;
    // var duration = milliseconds == null ? timeout : ms * milliseconds;
    // if (_timer != null) {
    //   _timer.cancel();
    // }
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (_minutes == 0 && _seconds == 0) {
          setState(() {
            timer.cancel();
          });
        } else if (_seconds > 0) {
          setState(() {
            _seconds = _seconds - 1;
          });
        } else {
          setState(() {
            _seconds = 59;
            _minutes = _minutes - 1;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    // _startTimer();
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
          Column(children: <Widget>[
            // add animal and items here
            Container(
              margin: EdgeInsets.only(
                top: 350,
              ),
              child: Image(
                image: AssetImage('assets/dog.jpg'),
              ),
            ),
            // timer widget here
            // Text('$_minutes:$_seconds')
            CustomTimer(),
          ]),
        ],
      ),
    );
  }

  static Widget endSession() {
    return Container();
    // popup asking if they finished/need extension/end session
    // reward coins
    // go back to homepage
  }
}
