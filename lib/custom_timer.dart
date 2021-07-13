import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/screens/homepage.dart';
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
  String taskName = globals.taskName;
  int duration = globals.timeSliderValue.round();
  int day = globals.day;
  int month = globals.month;
  String start = globals.taskStart;
  String end = globals.taskEnd;
  String tagName = globals.tagName;
  Color tagColor = globals.tagColor;
  var timer;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString()}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        // print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          // setState(() async {
          //   showDialog(
          //     context: context,
          //     builder: (BuildContext context) => _timeExtension(context),
          // //   );
          //   DateTime now = DateTime.now();
          //   String minuteStr = now.minute.toString().length == 1
          //       ? '0' + now.minute.toString()
          //       : now.minute.toString();
          //   String end = now.hour.toString() + ":" + minuteStr;
          //   globals.taskEnd = end;
          // });
          if (globals.extended) {
            setState(() async {
              showDialog(
                context: context,
                builder: (BuildContext context) => endSession(context),
              );
              DateTime now = DateTime.now();
              String minuteStr = now.minute.toString().length == 1
                  ? '0' + now.minute.toString()
                  : now.minute.toString();
              String end = now.hour.toString() + ":" + minuteStr;
              globals.taskEnd = end;
              await DatabaseService().updateExtension(taskName, globals.timeSliderValue.round(), end);
            });
          } else {
            setState(() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => _timeExtension(context),
              );
              DateTime now = DateTime.now();
              String minuteStr = now.minute.toString().length == 1
                  ? '0' + now.minute.toString()
                  : now.minute.toString();
              String end = now.hour.toString() + ":" + minuteStr;
              globals.taskEnd = end;
            });
          }
        }
      });
    });
  }

  cancelTimer() {
    timer.cancel();
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _exitSessionPopUp(context);
        });
        return false;
      },
      child: Column(
        children: [
          Text(
            timerText,
            style: TextStyle(fontSize: 50),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _endTaskEarly(context);
              });
            },
            child: Text(
              "Task Completed",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _exitSessionPopUp(BuildContext context) {
    // when back and home button events are triggered
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Are you sure you want to leave?"),
          content: Text("You will lose coins earned!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/");
                cancelTimer();
                // mark as incomplete on timeline?
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // how to pause timer
              },
              child: Text("No"),
            )
          ],
        )
    );
  }

  // figure out hardware buttons
  // figure out how to send notifications
  // if exit app -> send push notifs
  // if press back button -> popup
  // time extension -> add time to duration -> let users choose...

  // end early -> earn coins + go back to main page + cancel timer
  Future _endTaskEarly(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you have completed your task?"),
        content: Text("some motivational message"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => endSession(context),
                );
              });
              currentSeconds = timer.tick;
              cancelTimer();
              DateTime now = DateTime.now();
              String minuteStr = now.minute.toString().length == 1
                  ? '0' + now.minute.toString()
                  : now.minute.toString();
              String end = now.hour.toString() + ":" + minuteStr;
              globals.taskEnd = end;
              await DatabaseService()
                  .addCoins(globals.timeSliderValue.round() * 100);
              if (globals.extended) {
                await DatabaseService().updateExtension(taskName, currentSeconds, end);
              } else {
                await DatabaseService().addNewTask(taskName, currentSeconds, "$day/$month", start, end, tagName, tagColor.value, day, month);
              }
            },
            child: Text("Yes"),
          ), 
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text("No"),
          )
        ],
      )
    );
  }

  // on same task
  // extended by: duration
  // or just final duration
  Widget _timeExtension(BuildContext context) {
    // change global value issit or add to global value
    return AlertDialog(
          title: Text("Do you want to extend your session?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Text('Please indicate how long you want to extend the session and click yes to continue.'),
                    Slider(
                      value: globals.timeSliderValue,
                      onChanged: (newTiming) {
                        setState(() {
                          globals.timeSliderValue = newTiming;
                        });
                      },
                      min: 1,
                      max: 120,
                      label: globals.timeSliderValue.round().toString(),
                      divisions: 22,
                    ),
                  ],
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/mainfocus");
                globals.extended = true;
                await DatabaseService()
                    .addCoins(globals.timeSliderValue.round() * 100);
                await DatabaseService().addNewTask(taskName, globals.timeSliderValue.round(), "$day/$month", start, end, tagName, tagColor.value, day, month);
                // how to update in database hmm
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => endSession(context),
                  );
                });
                await DatabaseService()
                    .addCoins(globals.timeSliderValue.round() * 100);
                await DatabaseService().addNewTask(taskName, globals.timeSliderValue.round(), "$day/$month", start, end, tagName, tagColor.value, day, month);
              },
              child: Text("No"),
            )
          ],
        );
  }

  Widget endSession(BuildContext context) {
    return EndSession();
  }
}
