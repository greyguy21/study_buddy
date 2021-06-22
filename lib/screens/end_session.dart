import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Focus session completed!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("good job! You've earned $amt coins!"),
          TextButton(
            onPressed: () {
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
