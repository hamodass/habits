import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/model/habit_model.dart';
import 'package:habit_tracker_application_main/provider/database_provider.dart';
import 'package:habit_tracker_application_main/screens/popup%20screens/habit_edit_screen.dart';
import 'package:habit_tracker_application_main/screens/popup%20screens/habit_view_screen.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:habit_tracker_application_main/utilitis/loading.dart';
import 'package:line_icons/line_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> info = [];
  bool isLoading = false;
  var user = FirebaseAuth.instance.currentUser;

  Future? getHabits(String uid) {
    FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, top: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      // image: const DecorationImage(
                      //   fit: BoxFit.cover,
                      //   image: NetworkImage(
                      //       'https://firebasestorage.googleapis.com/v0/b/ht-project-d32b8.appspot.com/o/Me.jpeg?alt=media&token=23127851-aa7f-4ac8-9100-739c31cc229b'),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Active Habits"),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                thickness: 0.7,
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewHabit(
                                                  habit: data[index],
                                                )));
                                  },
                                  child: Container(
                                    height: 100,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 7,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      bottomLeft:
                                                          Radius.circular(20)),
                                              color: data[index].isCompleted!
                                                  ? Colors.green
                                                      .withOpacity(0.8)
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
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection('Habits')
                                                    .doc(user!.uid)
                                                    .collection('habit')
                                                    .doc(data[index].docID)
                                                    .delete();
                                                setState(() {
                                                  isLoading = true;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            });
                      } else {
                        return Container(child: Center(child: Loading()));
                      }
                    }),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kFullGreenColor,
          elevation: 3,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const EditScreen()));
          },
          tooltip: 'Create Habit',
          child: const Icon(
            Icons.add,
            // color: isDark ? AppColors.lightText1 : AppColors.darkText1,
          ),
        ),
      ),
    );
  }
}
