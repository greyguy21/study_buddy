import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/services/database.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().timeline,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

            List<QueryDocumentSnapshot> docRef = [];
            snapshot.data!.docs.forEach((doc) {
              docRef.add(doc);
            });
            return Scaffold(
              appBar: AppBar(
                title: Text("Timeline"),
              ),
              body: new ListView.builder(
                  itemCount: docRef.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Task: " + docRef[index].get("name")),
                      subtitle: Text("Duration: " + docRef[index].get("time").toString()),
                    );
                  }
              ),
            );
        },
        );
  }
}
