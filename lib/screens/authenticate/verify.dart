import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
     super.initState();
     user = _firebaseAuth.currentUser!;
     user.sendEmailVerification();
     timer = Timer.periodic(Duration(seconds: 5), (timer) {
       checkEmailVerified();
     });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline,
              color: Colors.lightBlue,
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "An email has been sent to ${user.email}. "
                    "Please verify.",
                style: TextStyle(
                  color: Colors.lightBlue,
                )
              ),
            )
          ],
        ),
      )
    );
  }

  Future<void> checkEmailVerified() async {
    user = _firebaseAuth.currentUser!;
    await user.reload();
    _firebaseAuth
        .authStateChanges()
        .listen((User? user) {
          if (user!.emailVerified) {
            timer.cancel();
            Navigator.pushReplacementNamed(context, "/");
          }
    });
  }
}
