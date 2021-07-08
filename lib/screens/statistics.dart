import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/models/app_user.dart';
import 'package:study_buddy/screens/homepage.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/screens/store/accessories_page.dart';
import 'package:study_buddy/screens/store/clothes_page.dart';
import 'package:study_buddy/screens/store/items_page.dart';
import 'package:study_buddy/screens/store/wallpapers_page.dart';
import 'package:study_buddy/services/database.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = now.day.toString() + "/" + now.month.toString();

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

          List<QueryDocumentSnapshot> todaysTasks = [];
          num totalTime = 0;
          snapshot.data!.docs.forEach((doc) {
            if (doc.get('date') == date) {
              todaysTasks.add(doc);
              totalTime = totalTime + doc.get('duration');
            }
          });

          return Scaffold(
            appBar: AppBar(
              title: Text("Statistics"),
            ),
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Today: $date",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: [
                          Text('Number of tasks completed'),
                          Text(
                            '${todaysTasks.length}',
                            style: TextStyle(fontSize: 50),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: [
                          Text('Amount of time focused'),
                          Text(
                            '$totalTime',
                            style: TextStyle(fontSize: 50),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // add more statistics stuff here
              ],
            ),
          );
        });
  }
}
