import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
 @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';

 @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('REGISTER'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  TextFormField(
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    obscureText: true,
                  ),
                ],
              )
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
      actions: <Widget>[
        Center(
          child: FloatingActionButton.extended(
            onPressed: () async {
              FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
              await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
              _firebaseAuth
                  .authStateChanges()
                  .listen((User? user)       {
                    if (user == null) {
                      print("nothing");
                    } else {
                      print("registration successful!");
                      Navigator.pushReplacementNamed(context, "/setup");
                    }
                  });
            },
            label: Text(
                "CONTINUE",
                style: TextStyle(
                  color: Colors.white,
                )
            ),
            backgroundColor: Colors.lightBlue,
          ),
        )
      ],
      // backgroundColor: Colors., (of start popup)
    );
  }
}
