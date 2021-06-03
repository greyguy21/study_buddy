import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../globals.dart' as globals;
import 'package:study_buddy/screens/menu.dart';

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
            margin: EdgeInsets.fromLTRB(20, 60, 50, 30),
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menu button
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/menu');
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
          TextField(
            decoration: InputDecoration(
              labelText: 'Task:',
            ),
            // onSubmitted: (value) => ,
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
            // go to main focus page
            // start focus session
            // a
            // d
            // d
            //
            // t
            // i
            // m
            // e
            // r
            //
            // h
            // e
            // r
            // e
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

double _timeSliderValue = 10;

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
      value: _timeSliderValue,
      onChanged: (newTiming) {
        setState(() => _timeSliderValue = newTiming);
      },
      min: 10,
      max: 120,
      label: _timeSliderValue.round().toString(),
      divisions: 22,
    );
  }
}
