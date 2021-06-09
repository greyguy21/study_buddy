import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../globals.dart' as globals;

class EndSession extends StatefulWidget {
  const EndSession({Key? key}) : super(key: key);

  @override
  _EndSessionState createState() => _EndSessionState();
}

class _EndSessionState extends State<EndSession> {
  int amt = globals.timeSliderValue.round();

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
              Navigator.pushNamed(context, "/");
            },
            child: Text('ok'),
          ),
        ],
      ),
    );
  }
}