import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/widgets/hero_dialog_route.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  TimeOfDay _timeOfDay =
      const TimeOfDay(hour: 0, minute: 00); // send to database
  timePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        _timeOfDay = value!;
      });
      try {
        FirebaseFirestore.instance
            .collection('habits')
            .doc('Reminders')
            .update({
          'Time': _timeOfDay,
          'Date': _timeOfDay,
        }).then((value) => const SnackBar(
                content: Text('Successfully Saved'))); //save to database
      } catch (e) {
        return const SnackBar(
          content: Text("Failed to save"),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return timePicker();
  }
}

String _heroReminderCard = 'add-hero';

class ReminderButton extends StatelessWidget {
  const ReminderButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const ReminderScreen();
            },
          ));
        },
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
    );
  }
}
