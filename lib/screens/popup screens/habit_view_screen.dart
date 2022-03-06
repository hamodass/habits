import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_tracker_application_main/model/choice_model.dart';
import 'package:habit_tracker_application_main/model/habit_model.dart';
import 'package:habit_tracker_application_main/screens/main%20screens/overview_screen.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:habit_tracker_application_main/utilitis/loading.dart';

class ViewHabit extends StatefulWidget {
  HabitModel? habit;
  ViewHabit({this.habit, Key? key}) : super(key: key);

  @override
  _ViewHabitState createState() => _ViewHabitState();
}

class _ViewHabitState extends State<ViewHabit> {
  bool isLoading = false;
  bool isComplted = false;
  var user = FirebaseAuth.instance.currentUser;
  @override
  // void initState() {
  //   isComplted = widget.habit!.isCompleted!;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey.shade100,
        ),
        body: isLoading
            ? Loading()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      decoration: BoxDecoration(color: Colors.grey.shade100),
                      child: Center(
                        child: Text(
                          widget.habit!.habitName!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ), //name
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey.shade100),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Habit History",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Wrap(children: [
                            ...widget.habit!.perWeek!
                                .map(
                                  (day) => Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: FilterChip(
                                      selected: day.isDone!,
                                      selectedColor: kLightGreenColor,
                                      avatar: const CircleAvatar(
                                        backgroundColor: kFullGreenColor,
                                      ),
                                      label: Text(
                                        day.name!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      onSelected: (bool selected) async {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('Habits')
                                            .doc(user!.uid)
                                            .collection('habit')
                                            .doc(widget.habit!.docID)
                                            .update({
                                          'perWeek': FieldValue.arrayRemove([
                                            {
                                              'index': day.index,
                                              'isDone': day.isDone,
                                              'name': day.name
                                            }
                                          ])
                                        }).then((value) {
                                          FirebaseFirestore.instance
                                              .collection('Habits')
                                              .doc(user!.uid)
                                              .collection('habit')
                                              .doc(widget.habit!.docID)
                                              .update({
                                            'perWeek': FieldValue.arrayUnion(
                                              [
                                                MyChoice(
                                                        index: day.index,
                                                        isDone: selected,
                                                        name: day.name)
                                                    .toJson()
                                              ],
                                            )
                                          });
                                          setState(() {
                                            day.isDone = selected;
                                          });
                                        });
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          ])
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   // width: double.maxFinite,
                    //   // height: 20,
                    //   decoration:
                    //       BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    //   child: Column(
                    //     children: [
                    //       const Text("Feeling Chart"),
                    //       Slider(min: 1, max: 5, value: 0, onChanged: onChanged),
                    //     ],
                    //   ),
                    // ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      // height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: SwitchListTile(
                          activeColor: kFullGreenColor,
                          title: const Text('Completed'),
                          value: widget.habit!.isCompleted!,
                          onChanged: (value) async {
                            setState(() {
                              isLoading = true;
                            });
                            setState(() {
                              widget.habit!.isCompleted = value;
                            });
                            await FirebaseFirestore.instance
                                .collection('Habits')
                                .doc(user!.uid)
                                .collection('habit')
                                .doc(widget.habit!.docID)
                                .update({'isCompleted': value});
                            setState(() {
                              isLoading = false;
                            });
                          }),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<StatefulWidget> onChanged(double value) async {
    double feelingValue;
    feelingValue = value;
    try {
      FirebaseFirestore.instance
          .collection('Habits')
          .doc('Habit')
          .update({'feelingChart': feelingValue}).then((value) =>
              const SnackBar(
                  content: Text('Successfully Saved'))); //save to database
    } catch (e) {
      return const SnackBar(
        content: Text("Failed to save"),
      );
    }
    return const CircularProgressIndicator();
  }

  void onCompleted(bool? value, String? uid) {
    try {
      setState(() {
        FirebaseFirestore.instance
            .collection('Habits')
            .doc(uid)
            .collection('habit')
            .doc()
            .update({'completed': value});
      });
      const SnackBar(content: Text('Data Saved Successfully')); // makes it true
    } catch (e) {
      const SnackBar(
        content: Text("Failed to save"),
      );
    }
  }
}

String _heroViewHabit = 'view-hero';

class ViewButton extends StatelessWidget {
  const ViewButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) {
          //     return const ViewHabit();
          //   },
          // ));
        },
        child: Hero(
          tag: _heroViewHabit,
          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}
