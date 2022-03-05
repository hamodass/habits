import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/model/habit_model.dart';
import 'package:habit_tracker_application_main/provider/database_provider.dart';
import 'package:habit_tracker_application_main/screens/popup%20screens/habit_view_screen.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:habit_tracker_application_main/utilitis/loading.dart';

class CompletedHabitsScreen extends StatefulWidget {
  CompletedHabitsScreen({Key? key}) : super(key: key);

  @override
  State<CompletedHabitsScreen> createState() => _CompletedHabitsScreenState();
}

class _CompletedHabitsScreenState extends State<CompletedHabitsScreen> {
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
          Image.asset(
            "assets/icons/crown.png",
            height: 100,
            width: 100,
            color: kFullGreenColor.withOpacity(0.5),
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'My Achivement',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Container(
              width: 500,
              margin: const EdgeInsets.all(20),
              child: StreamBuilder<List<HabitModel>>(
                  stream: DataBaseProvider().completedHabits(user!.uid),
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
                                          // trailing: IconButton(
                                          //   icon: const Icon(
                                          //     Icons.cancel_outlined,
                                          //     color: Colors.red,
                                          //     size: 20,
                                          //   ),
                                          //   onPressed: () async {
                                          //     setState(() {
                                          //       isLoading = true;
                                          //     });
                                          //     await FirebaseFirestore.instance
                                          //         .collection('Habits')
                                          //         .doc(user!.uid)
                                          //         .collection('habit')
                                          //         .doc(data[index].docID)
                                          //         .delete();
                                          //     setState(() {
                                          //       isLoading = true;
                                          //     });
                                          //   },
                                          // ),
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
