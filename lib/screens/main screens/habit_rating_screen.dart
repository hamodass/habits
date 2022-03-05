import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_tracker_application_main/model/habit_model.dart';
import 'package:habit_tracker_application_main/provider/database_provider.dart';
import 'package:habit_tracker_application_main/screens/main%20screens/overview_screen.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:habit_tracker_application_main/utilitis/loading.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class HabitRatingScreen extends StatefulWidget {
  HabitModel? habit;
  HabitRatingScreen({this.habit});
  @override
  _HabitRatingScreenState createState() => _HabitRatingScreenState();
}

class _HabitRatingScreenState extends State<HabitRatingScreen> {
  var myFeedbackText = "COULD BE BETTER";
  var sliderValue = 0.0;
  bool isLoading = false;
  IconData myFeedback = FontAwesomeIcons.sadTear;
  Color myFeedbackColor = Colors.red;
  TextEditingController? _commentController;
  @override
  void initState() {
    _commentController = TextEditingController(text: widget.habit!.comment!);
    sliderValue = widget.habit!.rate!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
      ),
      body: isLoading
          ? Loading()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "How do you feel now?",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    child: Material(
                      color: Colors.white,
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(24.0),
                      shadowColor: kFullGreenColor,
                      child: SizedBox(
                          width: 350.0,
                          height: 400.0,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  myFeedbackText,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 22.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  myFeedback,
                                  color: kFullGreenColor,
                                  size: 100.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Slider(
                                  min: 0.0,
                                  max: 5.0,
                                  divisions: 5,
                                  value: sliderValue,
                                  activeColor: kFullGreenColor,
                                  inactiveColor: Colors.blueGrey,
                                  onChanged: (newValue) {
                                    setState(() {
                                      sliderValue = newValue;
                                      if (sliderValue >= 0.0 &&
                                          sliderValue <= 1.0) {
                                        myFeedback = FontAwesomeIcons.sadTear;
                                        myFeedbackColor = Colors.red;
                                        myFeedbackText = "COULD BE BETTER";
                                      }
                                      if (sliderValue >= 1.0 &&
                                          sliderValue <= 2.0) {
                                        myFeedback = FontAwesomeIcons.frown;
                                        myFeedbackColor = Colors.yellow;
                                        myFeedbackText = "BELOW AVERAGE";
                                      }
                                      if (sliderValue >= 2.0 &&
                                          sliderValue <= 3.0) {
                                        myFeedback = FontAwesomeIcons.meh;
                                        myFeedbackColor = Colors.amber;
                                        myFeedbackText = "NORMAL";
                                      }
                                      if (sliderValue >= 3.0 &&
                                          sliderValue <= 4.0) {
                                        myFeedback = FontAwesomeIcons.smile;
                                        myFeedbackColor = Colors.green;
                                        myFeedbackText = "GOOD";
                                      }
                                      if (sliderValue >= 4.0 &&
                                          sliderValue <= 5.0) {
                                        myFeedback = FontAwesomeIcons.laugh;
                                        myFeedbackColor = Colors.pink;
                                        myFeedbackText = "EXCELLENT";
                                      }
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextField(
                                  controller: _commentController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blueGrey)),
                                    hintText: 'Add Comment',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    child: const Text(
                                      'Submit',
                                      style:
                                          TextStyle(color: Color(0xffffffff)),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('Habits')
                                          .doc(user!.uid)
                                          .collection('habit')
                                          .doc(widget.habit!.docID)
                                          .update({
                                        'comment': _commentController!.text,
                                        'rate': sliderValue
                                      });
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                      print(sliderValue);
                                      print(_commentController!.text);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

////////////////////////////
///
class RateCompletedHabitsScreen extends StatefulWidget {
  RateCompletedHabitsScreen({Key? key}) : super(key: key);

  @override
  State<RateCompletedHabitsScreen> createState() =>
      _RateCompletedHabitsScreenState();
}

class _RateCompletedHabitsScreenState extends State<RateCompletedHabitsScreen> {
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
          const Icon(
            Icons.star_border_outlined,
            color: kFullGreenColor,
            size: 100,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Select Habit to rate.',
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
                                          builder: (context) =>
                                              HabitRatingScreen(
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
                                          // subtitle: SimpleStarRating(
                                          //   // allowHalfRating: true,
                                          //   starCount: 5,
                                          //   rating: 3,
                                          //   size: 15,
                                          //   onRated: (rate) {},
                                          //   spacing: 10,
                                          // ),
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
                                          subtitle: Text(
                                            data[index].comment!,
                                            style: TextStyle(color: kBlack54),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          trailing: SimpleStarRating(
                                            // allowHalfRating: true,
                                            starCount: 5,
                                            rating: data[index].rate!,
                                            size: 15,
                                            // onRated: (rate) {},
                                            spacing: 10,
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
