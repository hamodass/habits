import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HabitProvider extends ChangeNotifier  {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  

  Future home(String uid, String hid) async {
    
    // try {
    //   if () {
    //     emit();
    //   }
    // } on FirebaseAuthException catch (e) {}
  }

  Future viewHabit(String uid, String hid) async {
    
    try {} on FirebaseAuthException catch (e) {}
  }

  Future createHabit(String name, bool often, bool perDay, bool? perWeek,
      bool timeOfDay) async {
    
    try {
      // emit();
    } on FirebaseAuthException catch (e) {
      // emit(); display error
    }
  }

  Future viewProfile(String uid, String hid) async {
 
    try {} on FirebaseAuthException catch (e) {}
  }

  Future editProfile(String uid, String hid) async {
   
    try {} on FirebaseAuthException catch (e) {}
  }

  detailScreen() {
   
  }
}