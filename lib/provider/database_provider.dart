import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:habit_tracker_application_main/model/choice_model.dart';
import 'package:habit_tracker_application_main/model/habit_model.dart';
import 'package:habit_tracker_application_main/model/user_model.dart';

class DataBaseProvider extends ChangeNotifier {
  CollectionReference habitsCollection =
      FirebaseFirestore.instance.collection('Habits');
  List<HabitModel> brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return HabitModel(
          docID: doc.id,
          habitName: doc['habitName'] ?? '',
          often: doc['often'] ?? '',
          hTimes: doc['hTimes'] ?? '',
          perWeek: doc["perWeek"] == null
              ? null
              : List<MyChoice>.from(
                  doc["perWeek"].map((x) => MyChoice.fromJson(x))),
          wTimes: doc['wTimes'] ?? '',
          isCompleted: doc['isCompleted'],
          createdDateTime: (doc['dateTime'] as Timestamp).toDate(),
          comment: doc['comment'] ?? '',
          rate: doc['rate'] ?? 0.0
          // time: Time.fromJson(doc['time']),
          );
    }).toList();
  }

  Stream<List<HabitModel>> habits(String uid) {
    return habitsCollection
        .doc(uid)
        .collection('habit')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map(brewListFromSnapshot);
  }

  Stream<List<HabitModel>> completedHabits(String uid) {
    return habitsCollection
        .doc(uid)
        .collection('habit')
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map(brewListFromSnapshot);
  }

  Stream<List<HabitModel>> completedDays(String uid) {
    return habitsCollection
        .doc(uid)
        .collection('habit')
        // .where('perWeek', arrayContainsAny: ['isDone', true])
        .snapshots()
        .map(brewListFromSnapshot);
  }

  

}
