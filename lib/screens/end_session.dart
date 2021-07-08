import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/services/database.dart';
import '../globals.dart' as globals;
import 'package:page_transition/page_transition.dart';
import 'package:study_buddy/screens/homepage.dart';

class EndSession extends StatefulWidget {
  const EndSession({Key? key}) : super(key: key);

  @override
  _EndSessionState createState() => _EndSessionState();
}

class _EndSessionState extends State<EndSession> {
  int amt = globals.timeSliderValue.round() * 100;
  String taskName = globals.taskName;
  int duration = globals.timeSliderValue.round();
  String date = globals.date;
  String start = globals.taskStart;
  String end = globals.taskEnd;
  String tagName = globals.tagName;
  Color tagColor = globals.tagColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Focus session completed!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("good job! You've earned $amt coins!"),
          TextButton(
            onPressed: () async {
              print(taskName);
              await DatabaseService().addNewTask(taskName, duration, date, start, end, tagName, tagColor.value);
              // await DatabaseService().updateTask(taskName,
              //     globals.timeSliderValue.round(), globals.date, globals.taskStart, globals.taskEnd, globals.tagName, globals.tagColor);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  PageTransition(
                      child: HomePage(), type: PageTransitionType.fade));
            },
            child: Text('ok'),
          ),
        ],
      ),
    );
  }
}
