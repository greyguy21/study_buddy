import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/screens/homepage.dart';
import 'package:study_buddy/services/database.dart';
import 'globals.dart' as globals;
import 'screens/end_session.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomTimer extends StatefulWidget {
  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> with WidgetsBindingObserver {
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
              await DatabaseService().updateExtension(
                  taskName, globals.timeSliderValue.round(), end);
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
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Stopwatch stopwatch = Stopwatch();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.paused == state) {
      stopwatch.start();
      NotificationService().showNotification();
      if (stopwatch.elapsedTicks >= 10) {
        setState(() {
          cancelTimer();
          _incompleteSession(context);
        });
        stopwatch.stop();
      }
    }

    if (AppLifecycleState.detached == state) {
      Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      if (stopwatch.elapsedTicks == 10) {
        cancelTimer();
        Navigator.pop(context);
        setState(() {
          _incompleteSession(context);
        });
        stopwatch.stop();
      }
    }
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

  Future _incompleteSession(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Incomplete Session!"),
        content: Text("Don't give up!"),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/");
              },
              child: Text("ok"),
            ),
          )
        ],
      )
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
            ));
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
              content: Text(
                  "Note: you will only receive the coins for the amount of time you have focused for!"),
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
                    int actual = (currentSeconds / 60).round() == 0
                        ? 1
                        : (currentSeconds / 60).round();
                    globals.earned = actual * 100;
                    await DatabaseService().addCoins(globals.earned);
                    if (globals.extended) {
                      await DatabaseService()
                          .updateExtension(taskName, actual, end);
                    } else {
                      await DatabaseService().addNewTask(
                          taskName,
                          actual,
                          "$day/$month",
                          start,
                          end,
                          tagName,
                          tagColor.value,
                          day,
                          month);
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
            ));
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
                Text(
                    'Please indicate how long you want to extend the session and click yes to continue.'),
                // Slider(
                //   value: globals.timeSliderValue,
                //   onChanged: (newTiming) {
                //     setState(() {
                //       globals.timeSliderValue = newTiming;
                //     });
                //   },
                //   min: 1,
                //   max: 120,
                //   label: globals.timeSliderValue.round().toString(),
                //   divisions: 22,
                // ),
                TimerSlider(),
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
            int earned = globals.timeSliderValue.round() * 100;
            globals.earned = earned;
            await DatabaseService().addCoins(earned);
            await DatabaseService().addNewTask(
                taskName,
                globals.timeSliderValue.round(),
                "$day/$month",
                start,
                end,
                tagName,
                tagColor.value,
                day,
                month);
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
            var earned = globals.timeSliderValue.round() * 100;
            globals.earned = earned;
            await DatabaseService().addCoins(earned);
            await DatabaseService().addNewTask(
                taskName,
                globals.timeSliderValue.round(),
                "$day/$month",
                start,
                end,
                tagName,
                tagColor.value,
                day,
                month);
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

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "main_focus",
      "Main Focus",
      "ask users to return to app",
      importance: Importance.high
  );
  static const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("logo");
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  int counter = 0;
  void showNotification() {
    flutterLocalNotificationsPlugin.show(0, "Study Buddy", "GO BACK!! 10s before session is terminated!", platformChannelSpecifics);
  }

  Future selectNotification(String? payload) async {
    // handle notification tapped logic
    print("hope it works");
  }
}
