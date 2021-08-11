import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/models/app_user.dart';
import '../globals.dart' as globals;
import 'package:study_buddy/screens/loading.dart';
import 'package:date_util/date_util.dart';
import 'package:study_buddy/services/database.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:study_buddy/screens/menu.dart';
import 'package:page_transition/page_transition.dart';

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
    var dateUtility = DateUtil();
    var numDays = dateUtility.daysInMonth(now.month, now.year);

    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().timeline,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          return StreamBuilder<AppUser>(
              stream: DatabaseService().users,
              builder: (context, tagsSnapshot) {
                int numOfTags = tagsSnapshot.data!.numOfTags;

                // adding all focus sessions into this list docRef
                List<QueryDocumentSnapshot> docRef = [];
                snapshot.data!.docs.forEach((doc) {
                  docRef.add(doc);
                });

                List<Task> listDayTasks = [];
                List<Task> listMonthTasks = [];
                List<DataPoint> lineData =
                    List.filled(numDays, new DataPoint(0, 0));
                for (int i = 0; i < numDays; i++) {
                  lineData[i] = new DataPoint(i + 1, 0);
                }
                List<String> listOfTags = List.filled(numOfTags, '');
                List<PieData> pieDataDay = List.filled(
                    numOfTags, new PieData('', 0, Color(0000000000)));
                List<PieData> pieDataMonth = List.filled(
                    numOfTags, new PieData('', 0, Color(0000000000)));

                num totalDayTime = 0;
                num totalMonthTime = 0;

                // processing data
                snapshot.data!.docs.forEach((doc) {
                  if (doc.get('month') == now.month) {
                    String docTag = doc.get('tag');
                    totalMonthTime = totalMonthTime + doc.get('duration');
                    listMonthTasks.add(new Task(
                        doc.get('name'),
                        docTag,
                        doc.get('duration'),
                        Color(doc.get('color')),
                        doc.get('day')));
                    lineData[doc.get('day') - 1].duration +=
                        doc.get('duration');
                    if (listOfTags.contains(docTag)) {
                      int index = listOfTags.indexOf(docTag);
                      pieDataMonth[index].duration += doc.get('duration');
                    } else {
                      int index = listOfTags.indexOf('');
                      listOfTags[index] = docTag;
                      pieDataMonth[index] = new PieData(
                          docTag, doc.get('duration'), Color(doc.get('color')));
                    }

                    if (doc.get('date') == date) {
                      totalDayTime = totalDayTime + doc.get('duration');
                      listDayTasks.add(new Task(
                          doc.get('name'),
                          doc.get('tag'),
                          doc.get('duration'),
                          Color(doc.get('color')),
                          doc.get('day')));

                      // adding data to pieDataDay
                      // tags alr processed in month so all the tags
                      // in this day would have been added already
                      // update color and tag name
                      int index = listOfTags.indexOf(docTag);
                      num curr = pieDataDay[index].duration;
                      pieDataDay[index] = new PieData(docTag,
                          doc.get('duration') + curr, Color(doc.get('color')));
                    }
                  }
                });

                return DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text("Statistics"),
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Menu(),
                                  type: PageTransitionType.leftToRight));
                        },
                      ),
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
                                      '${listDayTasks.length}',
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
                                  SizedBox(
                                    height: 400,
                                    child: TagPieChart(data: pieDataDay),
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
                                      '${listMonthTasks.length}',
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
                                  SizedBox(
                                    height: 400,
                                    child: TagPieChart(data: pieDataMonth),
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
                                      data: lineData,
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
        });
  }
}

class TagPieChart extends StatelessWidget {
  final List<PieData> data;

  TagPieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PieData, String>> series = [
      charts.Series(
        data: data,
        id: 'Tag Distribution',
        domainFn: (PieData task, _) => task.tagName, //x
        measureFn: (PieData task, _) => task.duration, //y
        colorFn: (PieData task, _) =>
            charts.ColorUtil.fromDartColor(task.color),
        labelAccessorFn: (PieData task, _) => task.duration.toString(),
      )
    ];

    return charts.PieChart(
      series,
      animate: true,
      behaviors: [
        new charts.DatumLegend(
            outsideJustification: charts.OutsideJustification.endDrawArea,
            horizontalFirst: false,
            desiredMaxRows: 2,
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
  final List<DataPoint> data;

  MonthLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DataPoint, int>> series = [
      charts.Series(
        data: data,
        id: 'Month Task Duration',
        domainFn: (DataPoint dp, _) => dp.name,
        measureFn: (DataPoint dp, _) => dp.duration,
        labelAccessorFn: (DataPoint dp, _) => dp.duration.toString(),
      )
    ];

    return charts.LineChart(
      series,
      animate: true,
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

class DataPoint {
  final int name;
  num duration;

  DataPoint(this.name, this.duration);
}

class PieData {
  String tagName;
  num duration;
  Color color;

  PieData(this.tagName, this.duration, this.color);
}
