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
    return Scaffold(
          appBar: AppBar(
            title: Text("Statistics"),
          ),
          // body: ,
        );
  }
}


