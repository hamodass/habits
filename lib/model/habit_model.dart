import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/model/choice_model.dart';

class HabitModel {
  String? docID;
  String? habitName;
  String? often;
  int? hTimes;
  List<MyChoice>? perWeek;
  String? wTimes;
  Time? time;
  DateTime? createdDateTime;
  bool? isCompleted;
  String? comment;
  double? rate;

  HabitModel(
      {this.docID,
      this.habitName,
      this.often,
      this.hTimes,
      this.perWeek,
      this.wTimes,
      this.time,
      this.isCompleted,
      this.createdDateTime,
      this.comment,
      this.rate});
}

class Time {
  String? hour;
  String? minute;
  Time({this.hour, this.minute});

  factory Time.fromJson(Map<dynamic, dynamic> json) {
    return Time(hour: json['hour'], minute: json['minute']);
  }
}
