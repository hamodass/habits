import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker_application_main/model/habit_model.dart';
import 'package:habit_tracker_application_main/provider/database_provider.dart';
import 'package:habit_tracker_application_main/screens/main%20screens/current_streak_screen.dart';
import 'package:habit_tracker_application_main/screens/main%20screens/habit_rating_screen.dart';
import 'package:habit_tracker_application_main/screens/main%20screens/live_chart.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:habit_tracker_application_main/utilitis/loading.dart';

import 'completed_habits_screen.dart';



class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

QuerySnapshot? snapshot;

class _OverviewScreenState extends State<OverviewScreen> {
  bool _noCategorySelected = false;
  HabitModel? _selectedValue;
  var user = FirebaseAuth.instance.currentUser;
  Widget dropDownMenuWidget(List<HabitModel> habit) {
    return DropdownButton(
        // value: _selectedValue,
        borderRadius: BorderRadius.circular(10),
        underline: Container(),
        hint: const Text('Select Habit'),
        items: habit.map((e) {
          return DropdownMenuItem<HabitModel>(
            value: e,
            child: Text(e.habitName!),
          );
        }).toList(),
        onChanged: (HabitModel? habit) {
          setState(() {
            if (habit != null) {
              _selectedValue = habit;
            }

            _noCategorySelected = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<List<HabitModel>>(
          stream: DataBaseProvider().habits(user!.uid),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            if (snapshot.hasData) {
              return StreamBuilder<List<HabitModel>>(
                  stream: DataBaseProvider().habits(user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Somthing Went Wrong'),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Loading();
                    }
                    if (snapshot.hasData) {
                      List<HabitModel> habitList = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Track Your Habit',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Wrap(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectCompletedHabitsScreen()));
                                  },
                                  child: Container(
                                    height: 130,
                                    width: 170,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/icons/confetti.png",
                                          height: 50,
                                          width: 50,
                                          color:
                                              kFullGreenColor.withOpacity(0.5),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'current Streak', // from database (not there yet)
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Text(
                                          'Current Streak',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 130,
                                  width: 170,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/icons/flame.png",
                                        height: 50,
                                        width: 50,
                                        color: kFullGreenColor.withOpacity(0.5),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        'longest Streak', // from database
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Text(
                                        'Longest Streak',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w100,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CompletedHabitsScreen()));
                                  },
                                  child: Container(
                                    height: 130,
                                    width: 170,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/icons/crown.png",
                                          height: 50,
                                          width: 50,
                                          color:
                                              kFullGreenColor.withOpacity(0.5),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          // snapshot.data!.docs[3]['completedHabits'] +
                                          'HABITS',
                                          //from database
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Text(
                                          'Habits Completed',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w100,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RateCompletedHabitsScreen()));
                                  },
                                  child: Container(
                                    height: 130,
                                    width: 170,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/icons/chat-arrow-grow.png",
                                          height: 50,
                                          width: 50,
                                          color:
                                              kFullGreenColor.withOpacity(0.5),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          // snapshot.data!.docs[3]['rate'],
                                          'Rate',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Text(
                                          'Completion Rate',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w100,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Loading();
                    }
                  });
            } else {
              return Loading();
            }
          },
        ),
      ),
    );
  }
}
