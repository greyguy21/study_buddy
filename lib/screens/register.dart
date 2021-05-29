import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
 @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
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
            key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) => val!.isEmpty || !val.contains("@")
                        ? "Enter a valid email"
                        : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  TextFormField(
                    validator: (val) => val!.isEmpty || val.length < 6
                        ? "Enter a valid password"
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password"),
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
              if (_formKey.currentState!.validate()) {
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
              }
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
