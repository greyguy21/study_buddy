import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/services/database.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isFirst: index == 0,
                  isLast: index == docRef.length - 1,
                  beforeLineStyle:
                      LineStyle(color: Colors.black.withOpacity(0.2)),
                  endChild: Card(
                    color: docRef[index].get("color") ?? Colors.white60,
                    child: Column(
                      children: [
                        Text(
                          "Task: " + docRef[index].get("name"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "Duration: " +
                              docRef[index].get("duration").toString(),
                        ),
                        Text(
                          "Date: " + docRef[index].get("date"),
                        ),
                        Text(
                          "Start: " + docRef[index].get("start"),
                        ),
                        Text(
                          "End: " + docRef[index].get("end"),
                        )
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
