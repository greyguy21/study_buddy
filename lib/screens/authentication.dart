import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        centerTitle: true,
        title: Text(
          "Study Buddy",
          style: TextStyle(
            color: Colors.white,
          )
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: Colors.lightBlue,
              // pop up?
              label: Text("LOGIN"),
            ),
            SizedBox(
              height: 7.0,
            ),
            FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: Colors.lightBlue,
              // sign in with email & password -> pop up ?
              label: Text("REGISTER"),
            ),
            SizedBox(
              height: 7.0,
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                await _firebaseAuth.signInAnonymously();
                _firebaseAuth
                    .authStateChanges()
                    .listen((User? user) {
                      if (user == null) {
                        print(" user is signed out");
                      } else {
                        print("user is signed in");
                      }
                });
                Navigator.pushReplacementNamed(context, "/setup");
              },
              backgroundColor: Colors.lightBlue,
              // sign in anonymously
              label: Text("CONTINUE AS GUEST"),
            )
          ],
        ),
      )
    );
  }
}

