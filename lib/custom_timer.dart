import 'dart:async';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'screens/main_focus.dart';

class CustomTimer extends StatefulWidget {
  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = globals.timeSliderValue.round() * 60;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString()}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        // print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          setState(() {
            globals.coins = globals.coins + globals.timeSliderValue.round();
          });
          Navigator.pushNamed(context, "/endSession");
          Navigator.pop(context); // check if this correct idk what it does
        }
      });
    });
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.timer),
        SizedBox(
          width: 5,
        ),
        Text(timerText)
      ],
    );
  }
}