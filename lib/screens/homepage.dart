import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../globals.dart' as globals;
import 'package:study_buddy/screens/menu.dart';
import 'package:study_buddy/screens/main_focus.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 20, right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // menu button
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Menu(),
                                type: PageTransitionType.leftToRight));
                      },
                      icon: Icon(
                        Icons.menu,
                        size: 30.0,
                      ),
                    ),
                    // showing amount of money
                    Row(
                      children: [
                        Icon(Icons.attach_money),
                        Text(globals.coins.toString(),
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              ),
              // add animal and items here
              Container(
                margin: EdgeInsets.only(
                  top: 350,
                ),
                child: Image(
                  image: AssetImage('assets/dog.jpg'),
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              showDialog(
                context: context,
                builder: (BuildContext context) => _startPopup(context),
              );
            });
          },
          label: Text(
            'start',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: const Icon(Icons.alarm_on),
          backgroundColor: Colors.green.shade300,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _startPopup(BuildContext context) {
    return new AlertDialog(
      title: const Text('Focus session settings'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (val) => val!.isEmpty ? "please enter task name" : null,
            decoration: InputDecoration(
              labelText: 'Task:',
              filled: true,
            ),
            onChanged: (val) {
              setState(() => globals.taskName = val);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Text('Time (in minutes):'),
                TimerSlider(),
              ],
            ),
          )
        ],
      ),
      actions: <Widget>[
        FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: MainFocusPage(), type: PageTransitionType.fade));
          },
          label: Text(
            'start',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.green,
            ),
          ),
          icon: const Icon(
            Icons.alarm_on,
            color: Colors.green,
          ),
          backgroundColor: Colors.white,
        )
      ],
      // backgroundColor: Colors., (of start popup)
    );
  }
}

// timer slider
class TimerSlider extends StatefulWidget {
  const TimerSlider({Key? key}) : super(key: key);

  @override
  _TimerSliderState createState() => _TimerSliderState();
}

class _TimerSliderState extends State<TimerSlider> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      value: globals.timeSliderValue,
      onChanged: (newTiming) {
        setState(() => globals.timeSliderValue = newTiming);
      },
      min: 1,
      max: 120,
      label: globals.timeSliderValue.round().toString(),
      divisions: 22,
    );
  }
}
