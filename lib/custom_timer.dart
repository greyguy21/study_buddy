import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_buddy/services/database.dart';
import 'globals.dart' as globals;
import 'screens/end_session.dart';

class CustomTimer extends StatefulWidget {
  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = globals.timeSliderValue.round() * 60;
  final String taskName = globals.taskName;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString()}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        // print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          setState(() async {
            showDialog(
              context: context,
              builder: (BuildContext context) => endSession(context),
            );
            await DatabaseService()
                .updateTimeline(taskName, globals.timeSliderValue.round());
          });
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
    return Text(
      timerText,
      style: TextStyle(fontSize: 50),
      textAlign: TextAlign.center,
    );
  }

  Widget endSession(BuildContext context) {
    return EndSession();
  }
}
