import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Loading",
                style: TextStyle(
                  color: Colors.lightBlue,
                )
              )
            )
          ],
        ),
      ),
    );
  }
}
