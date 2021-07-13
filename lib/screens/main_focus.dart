import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/custom_timer.dart';
import '../globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_buddy/models/app_user.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/services/database.dart';
import 'package:study_buddy/screens/menu.dart';
import 'package:study_buddy/screens/main_focus.dart';
import 'package:page_transition/page_transition.dart';

// this page only has the background wallpaper, animal & items,
// animal speech box, timer

class MainFocusPage extends StatefulWidget {
  @override
  _MainFocusPageState createState() => _MainFocusPageState();
}

class _MainFocusPageState extends State<MainFocusPage> {
  String taskName = globals.taskName;
  bool exit = false;

  @override
  void initState() {
    super.initState();
    exit = false;
  }

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
              body: Stack(
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/wallpaper/$wallpaperstr.png"),
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // task name to display
                  Container(
                      margin: EdgeInsets.only(top: 80),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Task: $taskName',
                                style: TextStyle(
                                  fontSize: 20,
                                  backgroundColor: Colors.white,
                                ))
                          ])),
                  // animal and items
                  Positioned(
                    top: 200,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Animal(pet, imgPath),
                    ),
                  ),
                  // timer widget
                  Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CustomTimer(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        });
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
