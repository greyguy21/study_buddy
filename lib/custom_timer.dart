import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String tagName = globals.tagName;

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
            DateTime now = DateTime.now();
            String date = now.month.toString() + "/" + now.day.toString();
            String start = globals.taskStart;
            String minuteStr = now.minute.toString().length == 1
                ? '0' + now.minute.toString()
                : now.minute.toString();
            String end = now.hour.toString() + ":" + minuteStr;
            await DatabaseService().updateTimeline(taskName,
                globals.timeSliderValue.round() * 100, date, start, end, tagName, globals.tagColor);
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
