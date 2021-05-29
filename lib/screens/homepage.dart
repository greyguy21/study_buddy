import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage('assets/defaultBg.jpeg'),
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
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
                      // go to menu page
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
          Text('Task: '),
          Text('Time: '),
        ],
      ),
      actions: <Widget>[
        FloatingActionButton.extended(
          onPressed: () {
            // go to main focus page
            // start focus session
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

class FocusPage extends StatefulWidget {
  @override
  _FocusPageState createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
