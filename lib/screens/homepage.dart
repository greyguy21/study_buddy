import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:study_buddy/models/app_user.dart';
import 'package:study_buddy/models/tag_model.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/services/database.dart';
import '../globals.dart' as globals;
import 'package:study_buddy/screens/menu.dart';
import 'package:study_buddy/screens/main_focus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  bool _visible = false;
  PanelController _pc1 = new PanelController();

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
          // tags = (get list of user tags from firestore)

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

                //animal here
                Positioned(
                  top: 200,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Animal(pet, imgPath),
                  ),
                ),
                Visibility(
                    maintainState: true,
                    maintainAnimation: true,
                    visible: _visible,
                    child: SlidingUpPanel(
                        controller: _pc1,
                        // onPanelOpened: () => PanelState.OPEN,
                        onPanelClosed: () {
                          setState(() {
                            _visible = !_visible;
                          });
                        },
                        header: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_upward_sharp),
                          ],
                        ),
                        panel: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    validator: (val) =>
                                        val!.isEmpty || val.length < 1
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
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 30, right: 30),
                                child: Column(
                                  children: [
                                    Text('Time (in minutes):'),
                                    TimerSlider(),
                                  ],
                                ),
                              ),
                              StreamBuilder<List<TagModel>>(
                                stream: DatabaseService().tags,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return _errorPopup(context);
                                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Loading();
                                  } else {
                                    final GlobalKey<TagsState> _tagKey = GlobalKey<TagsState>();

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, left: 30, right: 30, bottom: 20),
                                      child: Tags(
                                        key: _tagKey,
                                        itemCount: snapshot.data!.length,
                                        columns: 5,
                                        itemBuilder: (index) {
                                          return ItemTags(
                                              index: index,
                                              title: snapshot.data![index].title,
                                              activeColor: snapshot.data![index].color,
                                              color: Colors.black87,
                                              textActiveColor: Colors.white,
                                              textColor: Colors.white,
                                              onPressed: (value) {
                                                // setState(() {
                                                //   globals.tagName = snapshot.data![index].title;
                                                //   globals.tagColor = snapshot.data![index].color;
                                                // });
                                                globals.tagName = snapshot.data![index].title;
                                                print(globals.tagName);
                                                globals.tagColor = snapshot.data![index].color;
                                                print(globals.tagColor.toString());
                                              },
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                // child: Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 20.0, left: 30, right: 30, bottom: 20),
                                //   child: Column(
                                //     children: [
                                //       Text('Tag: '),
                                //       Padding(
                                //         padding: const EdgeInsets.all(20.0),
                                //         child: Row(
                                //           children: [
                                //             TextButton(
                                //               onPressed: () {},
                                //               child: Row(
                                //                 children: [
                                //                   Container(
                                //                     width: 20,
                                //                     height: 20,
                                //                     decoration: BoxDecoration(
                                //                         color: Colors.red,
                                //                         shape: BoxShape.circle),
                                //                   ),
                                //                   SizedBox(width: 10),
                                //                   Text('assignments',
                                //                       style: TextStyle(
                                //                           color: Colors.black)),
                                //                 ],
                                //               ),
                                //             )
                                //           ],
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FloatingActionButton.extended(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        DateTime now = DateTime.now();
                                        String minuteStr =
                                            now.minute.toString().length == 1
                                                ? '0' + now.minute.toString()
                                                : now.minute.toString();
                                        globals.taskStart =
                                            now.hour.toString() +
                                                ":" +
                                                minuteStr;
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: MainFocusPage(),
                                                type: PageTransitionType.fade));
                                        // Navigator.pushReplacementNamed(context, "/mainfocus");
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))),
              ],
            ),
            floatingActionButton: Visibility(
              visible: !_visible,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      _visible = !_visible;
                      _pc1.open();
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) => _startPopup(context),
                      // );
                    });
                    // _pc1.open();
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
              DateTime now = DateTime.now();
              String minuteStr = now.minute.toString().length == 1
                  ? '0' + now.minute.toString()
                  : now.minute.toString();
              globals.taskStart = now.hour.toString() + ":" + minuteStr;
              Navigator.push(
                  context,
                  PageTransition(
                      child: MainFocusPage(), type: PageTransitionType.fade));
              // Navigator.pushReplacementNamed(context, "/mainfocus");
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

class Animal extends StatefulWidget {
  late String animal;
  late String imgPath;
  Animal(String animal, String imgPath) {
    this.animal = animal;
    this.imgPath = imgPath;
  }

  @override
  _AnimalState createState() => _AnimalState();
}

class _AnimalState extends State<Animal> {
  @override
  Widget build(BuildContext context) {
    double topHeight = 0;
    double bottomHeight = 0;
    if (widget.animal == "hamster") {
      topHeight = 170;
      bottomHeight = 20;
    } else if (widget.animal == "rabbit") {
      topHeight = 100;
      bottomHeight = 50;
    } else if (widget.animal == "cat") {
      topHeight = 50;
      bottomHeight = 60;
    } else {
      // dog
      topHeight = 30;
    }

    return Container(
      child: Column(
        children: [
          SizedBox(
            height: topHeight,
          ),
          Expanded(child: Image.asset(widget.imgPath, fit: BoxFit.contain)),
          SizedBox(
            height: bottomHeight,
          ),
        ],
      ),
    );
  }
}

// stream of tags in database
// user has a list of tags -> collection?
// tag doc is name and color
// streambuilder --> need a tag stream!

// Tag Collection
// -> build the tags in database (retrieve data)
// -> add new tag (update data)
// -> remove tag (update data)

// User field
// need to get current user
// -> onPressed -> tag chosen -> update

// Tasks
// need to get current task -> another global variable??
// need to add

// figure out how to add & choose color palette
