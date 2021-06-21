import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/models/app_user.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/services/database.dart';
import '../globals.dart' as globals;
import 'package:study_buddy/screens/menu.dart';
import 'package:study_buddy/screens/main_focus.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser>(
      stream: DatabaseService().users,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorPopup(context);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else {
          String clothes = snapshot.data!.clothesInUse;
          String accessory = snapshot.data!.accessoryInUse;
          String pet = snapshot.data!.pet;
          String imgPath = "assets/$pet/${pet + clothes + accessory}.png";
          String wallpaperstr = snapshot.data!.wallpaper;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: <Widget>[
                Image(
                  image: AssetImage("assets/wallpaper/$wallpaperstr.png"),
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // menu button and coins
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
                      Row(
                        children: [
                          Icon(Icons.attach_money),
                          // Text(globals.coins.toString(),
                          //     style: TextStyle(fontSize: 20)),
                          Text(
                            "${snapshot.data!.coins}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // animal and items
                Positioned(
                  top: 200,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Image(
                      image: AssetImage(imgPath),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 80),
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        }
      },
    );
  }

  Widget _startPopup(BuildContext context) {
    return new AlertDialog(
      title: const Text('Focus session settings'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              validator: (val) => val!.isEmpty || val.length < 1
                  ? "please enter task name"
                  : null,
              decoration: InputDecoration(
                labelText: 'Task:',
                filled: true,
              ),
              onChanged: (val) {
                // setState(() => globals.taskName = val);
                globals.taskName = val;
              },
            ),
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
            if (_formKey.currentState!.validate()) {
              Navigator.push(
                  context,
                  PageTransition(
                      child: MainFocusPage(), type: PageTransitionType.fade));
            }
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

  Widget _errorPopup(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'An error has occurred in retrieving user data, please try again later.'),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ok'),
          ),
        ],
      ),
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
