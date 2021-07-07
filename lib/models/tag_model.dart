import 'package:flutter/material.dart';

class TagModel{
  late String title;
  late int value;
  late Color color;

  TagModel(String title, int value) {
    this.title = title;
    this.value = value;
    this.color = Color(value);
  }
}