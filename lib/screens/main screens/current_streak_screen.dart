import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/model/choice_model.dart';
import 'package:habit_tracker_application_main/model/habit_model.dart';
import 'package:habit_tracker_application_main/provider/database_provider.dart';
import 'package:habit_tracker_application_main/screens/popup%20screens/habit_view_screen.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:habit_tracker_application_main/utilitis/loading.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'live_chart.dart';

class CurrentStreakScreen extends StatefulWidget {
  HabitModel? habitModel;
  CurrentStreakScreen({this.habitModel, Key? key}) : super(key: key);

  @override
  State<CurrentStreakScreen> createState() => _CurrentStreakScreenState();
}

class _CurrentStreakScreenState extends State<CurrentStreakScreen> {
  List<MyChoice> _finshedDays = [];
  int? _daysLength = 0;

  getTotalDaysLength() {
    _daysLength = widget.habitModel!.perWeek!.length;
  }

  getFinishedDays() async {
    int? _choiceIndex;
    if (widget.habitModel!.perWeek!.contains({'isDone': true})) {}

    widget.habitModel!.perWeek!.forEach((choice) {
      if (choice.isDone == true) {
        setState(() {
          _finshedDays.add(choice);
        });
      }
    });
    print(_finshedDays.length);
  }

  @override
  void initState() {
    getTotalDaysLength();
    getFinishedDays();

    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
      ),
      body: StreamBuilder<List<HabitModel>>(
          stream: DataBaseProvider().completedDays(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something Went Wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            if (snapshot.hasData) {
              List<HabitModel> habits = snapshot.data!;
              return Builder(builder: (context) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade200,
                        ),
                        child: LiveChartWidget(
                          habits: widget.habitModel,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Divider(
                          thickness: 0.8,
                        ),
                      ),
                      CircularStepProgressIndicator(
                        startingAngle: 0,
                        gradientColor: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: [
                            kFullGreenColor,
                            kFullGreenColor.withOpacity(0.5)
                          ],
                        ),
                        totalSteps: _daysLength!,
                        currentStep: _finshedDays.length,
                        stepSize: 5,
                        selectedColor: kFullGreenColor,
                        unselectedColor: Colors.grey[200],
                        padding: 0,
                        width: 200,
                        height: 200,
                        selectedStepSize: 20,
                        child: Center(
                            child: Text(
                          '${_finshedDays.length}/${_daysLength}',
                          style: TextStyle(fontSize: 20),
                        )),
                        roundedCap: (_, __) => true,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Divider(
                          thickness: 0.8,
                        ),
                      ),
                      Container(
                          child: Wrap(children: [
                        ...widget.habitModel!.perWeek!
                            .map(
                              (day) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: FilterChip(
                                  selected: day.isDone!,
                                  selectedColor:
                                      kLightGreenColor.withOpacity(0.5),
                                  avatar: const CircleAvatar(
                                    backgroundColor: kFullGreenColor,
                                  ),
                                  label: Text(
                                    day.name!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  onSelected: (bool selected) async {},
                                ),
                              ),
                            )
                            .toList(),
                      ]))
                    ],
                  ),
                );
              });
            } else {
              return Loading();
            }
          }),
    );
  }
}

///////////////////////////////////////////
///import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:habit_tracker_application_main/model/habit_model.dart';
// import 'package:habit_tracker_application_main/provider/database_provider.dart';
// import 'package:habit_tracker_application_main/screens/popup%20screens/habit_view_screen.dart';
// import 'package:habit_tracker_application_main/utilitis/constants.dart';
// import 'package:habit_tracker_application_main/utilitis/loading.dart';

class SelectCompletedHabitsScreen extends StatefulWidget {
  SelectCompletedHabitsScreen({Key? key}) : super(key: key);

  @override
  State<SelectCompletedHabitsScreen> createState() =>
      _SelectCompletedHabitsScreenState();
}

class _SelectCompletedHabitsScreenState
    extends State<SelectCompletedHabitsScreen> {
  bool isLoading = false;
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            "assets/icons/confetti.png",
            height: 100,
            width: 100,
            color: kFullGreenColor.withOpacity(0.5),
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Select Habit.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Divider(
              thickness: 1,
            ),
          ),
          Expanded(
            child: Container(
              width: 500,
              margin: const EdgeInsets.all(20),
              child: StreamBuilder<List<HabitModel>>(
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
                      List<HabitModel> data = snapshot.data!;

                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => ViewHabit(
                                  //               habit: data[index],
                                  //             )));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CurrentStreakScreen(
                                                habitModel: data[index],
                                              )));
                                },
                                child: Container(
                                  height: 100,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    bottomLeft:
                                                        Radius.circular(20)),
                                            color: data[index].isCompleted!
                                                ? Colors.green.withOpacity(0.8)
                                                : Colors.redAccent
                                                    .withOpacity(0.5)),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            data[index]
                                                .habitName!, // name .name not toStrin
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          subtitle: Text(
                                              "${data[index].createdDateTime!.day}/${data[index].createdDateTime!.month}/${data[index].createdDateTime!.year}  ${data[index].createdDateTime!.hour}:${data[index].createdDateTime!.minute}"),
                                          leading: CircleAvatar(
                                            backgroundColor: kFullGreenColor
                                                .withOpacity(0.5),
                                            child: Center(
                                                child: Text(
                                              '${data[index].hTimes!}',
                                              style: const TextStyle(
                                                  color: kBlack54),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          });
                    } else {
                      return Center(child: Loading());
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
