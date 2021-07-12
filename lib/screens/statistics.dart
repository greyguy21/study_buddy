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
    var monthStr = DateFormat.MMMM().format(now);

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
          List<QueryDocumentSnapshot> monthsTasks = [];
          List<Task> listOfTasks = [];
          List<Task> listMonthTasks = [];
          num totalDayTime = 0;
          num totalMonthTime = 0;
          snapshot.data!.docs.forEach((doc) {
            if (doc.get('month') == now.month) {
              monthsTasks.add(doc);
              totalMonthTime = totalMonthTime + doc.get('duration');
              listMonthTasks.add(new Task(
                  doc.get('name'),
                  doc.get('tag'),
                  doc.get('duration'),
                  Color(doc.get('color')),
                  doc.get('day')));

              if (doc.get('date') == date) {
                todaysTasks.add(doc);
                totalDayTime = totalDayTime + doc.get('duration');
                listOfTasks.add(new Task(
                    doc.get('name'),
                    doc.get('tag'),
                    doc.get('duration'),
                    Color(doc.get('color')),
                    doc.get('day')));
              }
            }
          });

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Statistics"),
                bottom: TabBar(
                  tabs: [Tab(text: 'Day'), Tab(text: 'Month')],
                ),
              ),
              body: TabBarView(children: [
                // daily statistics
                ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Today: $dateString",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
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
                                '$totalDayTime',
                                style: TextStyle(fontSize: 50),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Tag Distribution',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold)),
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
                // monthly statistics
                ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "This month: $monthStr",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
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
                                '${monthsTasks.length}',
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
                                '$totalMonthTime',
                                style: TextStyle(fontSize: 50),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Tag Distribution',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            // charts.PieChart(_series),
                            SizedBox(
                              height: 400,
                              child: TagPieChart(data: listMonthTasks),
                            ),
                          ],
                        )),
                    // add more month stats here
                    Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Monthly Focus Time Distribution',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            // charts.PieChart(_series),
                            SizedBox(
                              child: MonthLineChart(
                                data: listMonthTasks,
                              ),
                              height: 300,
                            ),
                          ],
                        )),
                  ],
                ),
              ]),
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

class MonthLineChart extends StatelessWidget {
  final List<Task> data;

  MonthLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Task, int>> series = [
      charts.Series(
        data: data,
        id: 'Month Task Duration',
        domainFn: (Task task, _) => task.day,
        measureFn: (Task task, _) => task.duration,
        // colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.color),
        // new Color(doc.get('color')),
        labelAccessorFn: (Task task, _) => task.duration.toString(),
      )
    ];

    return charts.LineChart(
      series,
      animate: true,
      // behaviors: [
      //   new charts.DatumLegend(
      //       outsideJustification: charts.OutsideJustification.endDrawArea,
      //       horizontalFirst: true,
      //       desiredMaxRows: 2,
      //       // cellPadding: EdgeInsets.only(),
      //       entryTextStyle: charts.TextStyleSpec(
      //         fontSize: 15,
      //         color: charts.MaterialPalette.black,
      //       ))
      // ],
      // defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
      //   new charts.ArcLabelDecorator(
      //       labelPosition: charts.ArcLabelPosition.inside)
      // ]),
    );
  }
}

class Task {
  final String taskName;
  final String tagName;
  final int duration;
  final Color color;
  final int day;

  Task(this.taskName, this.tagName, this.duration, this.color, this.day);
}
