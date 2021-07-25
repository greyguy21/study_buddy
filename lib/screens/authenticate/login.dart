import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";
  bool err = false;

  @override
  void initState() {
    super.initState();
    err = false;
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('LOGIN'),
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
              )),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
      actions: <Widget>[
        Center(
          child: FloatingActionButton.extended(
            onPressed: () async {
              try {
                if (_formKey.currentState!.validate()) {
                  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                  await _firebaseAuth.signInWithEmailAndPassword(
                      email: email, password: password);
                  _firebaseAuth.authStateChanges().listen((User? user) {
                    if (user == null) {
                      print("nothing");
                    } else {
                      print("login successful!");
                      Navigator.pushReplacementNamed(context, "/");
                    }
                  });
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == "user-not-found") {
                  setState(() {
                    error = "No user found for that email.";
                    err = true;
                  });
                } else if (e.code == "wrong-password") {
                  setState(() {
                    error = "Wrong password provided for that user, please try again.";
                    err = true;
                  });
                }
              }
            },
            label: Text("CONTINUE",
                style: TextStyle(
                  color: Colors.white,
                )),
            backgroundColor: Colors.lightBlue,
          ),
        ),
        SizedBox(height: 10.0),
        Visibility(
          visible: err,
          child: Text(error,
              style: TextStyle(
                color: Colors.red,
              )),
        )
      ],
      // backgroundColor: Colors., (of start popup)
    );
  }
}
