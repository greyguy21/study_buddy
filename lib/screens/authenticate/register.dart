import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_buddy/services/database.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool err = false;

  @override
  void initState() {
    err = false;
  }

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
                  await _firebaseAuth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  _firebaseAuth.authStateChanges().listen((User? user) async {
                    if (user == null) {
                      print("nothing");
                    } else {
                      print("registration successful!");
                      await DatabaseService().newUser();
                      Navigator.pushReplacementNamed(context, "/verify");
                    }
                  });
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == "weak-password") {
                  setState(() {
                    error = "The password provided is too weak.";
                    err = true;
                  });
                } else if (e.code == "email-already-in-use") {
                  setState(() {
                    error = "The account already exists for that email, please log in instead.";
                    err = true;
                  });
                }
              } catch (e) {
                print(e);
                setState(() {
                  error = "Error occurred when registering";
                  err = true;
                });
              }
            },
            label: Text("CONTINUE",
                style: TextStyle(
                  color: Colors.white,
                )),
            backgroundColor: Colors.lightBlue,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Visibility(
          visible: err,
          child: Center(
            child: Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                )),
          ),
        )
      ],
      // backgroundColor: Colors., (of start popup)
    );
  }
}
