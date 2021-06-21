import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:study_buddy/screens/authenticate/authentication.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _initialBool = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('User details:'),
              subtitle:
                  Text('Email: ${FirebaseAuth.instance.currentUser!.email}'),
            ),
            ListTile(
              leading: Icon(Icons.circle_notifications_outlined),
              title: Text('Notifications'),
              trailing: Switch(
                value: _initialBool,
                onChanged: (bool newValue) {
                  setState(() {
                    _initialBool = newValue;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 400),
              child: ListTile(
                tileColor: Colors.grey.shade100,
                title: Center(child: Text('Sign Out')),
                onTap: () async {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _confirmSignOutPopup(context),
                    );
                  });
                },
              ),
            ),
          ],
        ));
  }

  Widget _confirmSignOutPopup(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Confirm sign out?'),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) =>
                  // Navigator.pop(context);
                  Navigator.popAndPushNamed(context, "/authenticate"));
            },
            child: Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
