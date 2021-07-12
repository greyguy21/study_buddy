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
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
    var dateString = DateFormat.yMMMMd().format(now);

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
          List<Task> listOfTasks = [];
          num totalTime = 0;
          snapshot.data!.docs.forEach((doc) {
            if (doc.get('date') == date) {
              todaysTasks.add(doc);
              totalTime = totalTime + doc.get('duration');
              listOfTasks.add(new Task(doc.get('name'), doc.get('tag'),
                  doc.get('duration'), Color(doc.get('color'))));
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
                    "Today: $dateString",
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
                Container(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Tag Distribution'),
                      ],
                    ),
                    // charts.PieChart(_series),
                    SizedBox(
                      height: 400,
                      child: TagPieChart(data: listOfTasks),
                    ),
                  ],
                )),
              ],
            ),
          );
        });
  }
}

class TagPieChart extends StatelessWidget {
  final List<Task> data;

  TagPieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Task, String>> series = [
      charts.Series(
        data: data,
        id: 'Tag Distribution',
        domainFn: (Task task, _) => task.tagName,
        measureFn: (Task task, _) => task.duration,
        colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.color),
        // new Color(doc.get('color')),
        labelAccessorFn: (Task task, _) => task.duration.toString(),
      )
    ];

    return charts.PieChart(
      series,
      animate: true,
      behaviors: [
        new charts.DatumLegend(
            outsideJustification: charts.OutsideJustification.endDrawArea,
            horizontalFirst: true,
            desiredMaxRows: 2,
            // cellPadding: EdgeInsets.only(),
            entryTextStyle: charts.TextStyleSpec(
              fontSize: 15,
              color: charts.MaterialPalette.black,
            ))
      ],
      defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
        new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside)
      ]),
    );
  }
}

class Task {
  final String taskName;
  final String tagName;
  final int duration;
  final Color color;

  Task(this.taskName, this.tagName, this.duration, this.color);
}
