library study_buddy.globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var coins = 0;
double timeSliderValue = 10;
var taskName = '';
var taskStart = '';
var taskEnd = "";
var tagName = "Unset";
var tagColor = Color(Colors.grey.value);
var day = 0;
var month = 0;
var extended = false;
int earned = 0;
List<String> tasks = [];
