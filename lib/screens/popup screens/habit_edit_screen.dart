import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:habit_tracker_application_main/model/choice_model.dart';
import 'package:habit_tracker_application_main/provider/habit_provider.dart';
import 'package:habit_tracker_application_main/screens/login_and_register/widget/form_field.dart';
import 'package:habit_tracker_application_main/screens/popup%20screens/reminders_screen.dart';
import 'package:habit_tracker_application_main/services/firebase_auth.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:habit_tracker_application_main/utilitis/loading.dart';
import 'package:habit_tracker_application_main/widgets/hero_dialog_route.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  TextEditingController _habitController = TextEditingController();
  bool isLoading = false;
  // visible() {
  //   if (often[1] == true) {
  //     setState(() {
  //       isVisible = !isVisible;
  //     });
  //   }
  // }
  TimeOfDay? time;
  String? getTime() {
    if (time == null) {
      return 'Select Time';
    } else {
      final hour = time!.hour.toString().padLeft(2, '0');
      final minute = time!.minute.toString().padLeft(2, '0');
      return '$hour : $minute';
    }
  }

  Map timeOfDayToFirebase(TimeOfDay timeOfDay) {
    return {
      'hour': timeOfDay.hour,
      'minute': timeOfDay.minute,
    };
  }

  bool isVisible = false;
  int num = 0;
  //
  int? groupValue;

  //
  String? oftenValue;
  String? perWeekValue;
  String? timeOfDayValue;

  //often Choice
  String defult_often_choice = 'Daily';
  int default_often_index = 0;
  //per week Choice
  String defult_perWeek_choice = 'Sat';
  int default_perWeek_index = 0;
  //time of a day Choice
  String defult_timeOfDay_choice = 'Morning';
  int default_timeOfDay_index = 0;
  List<bool> often = [
    true,
    false,
    false,
  ];
  List<bool> week = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<bool> timeofDay = [
    true,
    false,
    false,
  ];

  //Data List
  final List<MyChoice> _oftenList = <MyChoice>[
    MyChoice(name: 'Daily', index: 0, isDone: false),
    MyChoice(name: 'Weekly', index: 1, isDone: false),
    MyChoice(name: 'Monthly', index: 2, isDone: false),
  ];
  //
  final List<MyChoice> _perWeekList = <MyChoice>[
    MyChoice(name: 'Saturday', index: 0, isDone: false),
    MyChoice(name: 'Sunday', index: 1, isDone: false),
    MyChoice(name: 'Monday', index: 2, isDone: false),
    MyChoice(name: 'Tuesday', index: 3, isDone: false),
    MyChoice(name: 'Wednesday', index: 4, isDone: false),
    MyChoice(name: 'Thursday', index: 5, isDone: false),
    MyChoice(name: 'Friday', index: 6, isDone: false),
  ];

  List<MyChoice> _selectedPerWeek = [];
  saveSelectedDays() {
    List<MyChoice> _newList = [];

    _selectedPerWeek.forEach((item) {
      _newList.add(item);
    });

    return _newList.toList();
  }

  //
  final List<MyChoice> _timeOfDayList = <MyChoice>[
    MyChoice(name: 'Morning', index: 0, isDone: false),
    MyChoice(name: 'Afternoon', index: 1, isDone: false),
    MyChoice(name: 'Eveing', index: 2, isDone: false),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthServices>(context);
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Loading()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: FormBuilder(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.arrow_back)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: FormWidget(
                          onTap: () {},
                          controller: _habitController,
                          lableText: 'Enter Habit Name',
                          validator: (val) =>
                              val.isEmpty ? 'Enter Habit Name' : null,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: [
                          const Text(
                            "How often do you want to do it",
                            style: TextStyle(
                                // color: isDark
                                //     ? AppColors.darkText2
                                //     : AppColors.lightText2,
                                fontSize: 16),
                          ),
                          const Divider(),
                          Column(
                            children: _oftenList
                                .map(
                                  (MyChoice data) => RadioListTile<int>(
                                      activeColor: kFullGreenColor,
                                      title: Text('${data.name}'),
                                      value: data.index!,
                                      groupValue: default_often_index,
                                      onChanged: (value) {
                                        setState(() {
                                          default_often_index = data.index!;
                                          defult_often_choice = data.name!;
                                          oftenValue = data.name;
                                          print(data.name);
                                        });
                                      }),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          const Text(
                            "How many times per day",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderField(
                              name: 'perday',
                              builder: (field) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          num--;
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            color: kcolor,
                                            shape: BoxShape.circle),
                                        child: const Center(
                                          child: Text(
                                            '-',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      num.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        // color: isDark
                                        // ? AppColors.darkText1
                                        // : AppColors.lightText1,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          num++;
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            color: kcolor,
                                            shape: BoxShape.circle),
                                        child: const Center(
                                          child: Text(
                                            '+',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: [
                          const Text(
                            "What days per week",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Divider(),
                          Column(
                            children: _perWeekList
                                .map(
                                  (MyChoice data) => CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: kFullGreenColor,
                                      title: Text('${data.name}'),
                                      value: data.value,
                                      onChanged: (value) {
                                        setState(() {
                                          data.value = value!;
                                          default_perWeek_index = data.index!;
                                          defult_perWeek_choice = data.name!;
                                          perWeekValue = data.name;
                                          if (data.value == true) {
                                            _selectedPerWeek.add(data);
                                          } else {
                                            _selectedPerWeek.remove(data);
                                          }
                                          print(_selectedPerWeek.length);
                                        });
                                      }),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        width: double.maxFinite,
                        child: Column(
                          children: [
                            const Text(
                              "What time of day",
                              style: TextStyle(
                                  // color: isDark
                                  //     ? AppColors.darkText2
                                  //     : AppColors.lightText2,
                                  fontSize: 16),
                            ),
                            const Divider(),
                            Container(
                              child: Column(
                                children: _timeOfDayList
                                    .map(
                                      (MyChoice data) => RadioListTile<int>(
                                          activeColor: kFullGreenColor,
                                          title: Text('${data.name}'),
                                          value: data.index!,
                                          groupValue: default_timeOfDay_index,
                                          onChanged: (value) {
                                            setState(() {
                                              default_timeOfDay_index =
                                                  data.index!;
                                              defult_timeOfDay_choice =
                                                  data.name!;
                                              timeOfDayValue = data.name;
                                              print(data.name);
                                            });
                                          }),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          timePicker();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (_) => const ReminderScreen()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Set Reminder",
                          ),
                        ),
                      ),
                      Text(getTime()!),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          child: const Text("Apply"),
                          onPressed: () async {
                            // if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            var _currentUser =
                                await FirebaseAuth.instance.currentUser!;
                            await FirebaseFirestore.instance
                                .collection('Habits')
                                .doc(_currentUser.uid)
                                .collection('habit')
                                .add({
                              'habitName': _habitController.text,
                              'often': oftenValue ?? defult_often_choice,
                              'hTimes': num,
                              'perWeek': _selectedPerWeek
                                  .map((element) => element.toJson())
                                  .toList(),
                              'wTimes':
                                  timeOfDayValue ?? defult_timeOfDay_choice,
                              'isCompleted': false,
                              'dateTime': DateTime.now(),
                              'comment': '',
                              'rate': 0.0
                              // 'time': timeOfDayToFirebase(time!),
                            }).then((value) {
                              print('Done');
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                              _habitController.clear();
                            });
                          }

                          // },

                          )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  timePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        time = value!;
      });
    });
  }
}

String _heroEditHabit = 'edit-hero';

class EditButton extends StatelessWidget {
  const EditButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(
            builder: (context) {
              return const EditScreen();
            },
          ));
        },
        child: Hero(
          tag: _heroEditHabit,
          child: Material(
            // color: AppColors.mainColor,
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

const kHintStyle = TextStyle(fontSize: 13, letterSpacing: 1.2);

var kOutlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(color: Colors.transparent),
);

var kErrorOutlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(color: Colors.red),
);

const kLoaderBtn = SizedBox(
  height: 20,
  width: 20,
  child: CircularProgressIndicator(
    strokeWidth: 1.5,
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  ),
);
