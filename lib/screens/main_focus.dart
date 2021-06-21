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
            return Scaffold(
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
                      Container(
                          margin: EdgeInsets.only(top: 80),
                          child: Text('Task: $taskName',
                              style: TextStyle(fontSize: 20))),
                      // add animal and items here
                      Container(
                        margin: EdgeInsets.only(
                          top: 150,
                        ),
                        child: Image(
                          image: AssetImage(imgPath),
                        ),
                      ),
                      // timer widget
                      Expanded(
                        child: Container(
                          // margin: EdgeInsets.only(top: 50),
                          child: CustomTimer(),
                        ),
                      ),
                    ]),
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
