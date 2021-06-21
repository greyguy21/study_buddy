import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/screens/authenticate/login.dart';
import 'package:study_buddy/screens/authenticate/register.dart';
import 'package:study_buddy/services/database.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Study Buddy",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Login(),
                    );
                  });
                },
                backgroundColor: Colors.lightBlue,
                // pop up?
                label: Text("LOGIN"),
              ),
              SizedBox(
                height: 7.0,
              ),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Register(),
                    );
                  });
                },
                backgroundColor: Colors.lightBlue,
                // sign in with email & password -> pop up ?
                label: Text("REGISTER"),
              ),
              SizedBox(
                height: 7.0,
              ),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () async {
                  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                  await _firebaseAuth.signInAnonymously();
                  _firebaseAuth.authStateChanges().listen((User? user) async {
                    if (user == null) {
                      print(" user is signed out");
                    } else {
                      print("user is signed in");
                      await DatabaseService().newUser();
                      Navigator.pushReplacementNamed(context, "/setup");
                    }
                  });
                },
                backgroundColor: Colors.lightBlue,
                // sign in anonymously
                label: Text("CONTINUE AS GUEST"),
              ),
            ],
          ),
        ));
  }
}
