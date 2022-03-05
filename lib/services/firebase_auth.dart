import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habit_tracker_application_main/model/user_model.dart';

import 'package:habit_tracker_application_main/screens/main_screen/main_screen.dart';

class AuthServices {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.displayName!, user.email!);
  }

  //User Stream From Firebase
  Stream<User?>? get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // Sign In
  Future<User?> signIn(
      String email, String password, BuildContext context) async {
    try {
      auth.UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        Fluttertoast.showToast(
            msg: 'The Login was Successful',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade200,
            textColor: Colors.black,
            fontSize: 14.0);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      } else {
        return null;
      }
      return _userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: 'No user found for that email.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: 'Wrong password provided for that user.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }
    return null;
  }

  //Sign Up
  Future<User?> signUp(
      String email, String password, String name, BuildContext context) async {
    try {
      auth.UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential != null) {
        credential.user!.updateDisplayName(name);
      }
      if (user != null) {
        Fluttertoast.showToast(
            msg: 'The Registeration was Successful',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey.shade200,
            textColor: Colors.black,
            fontSize: 14.0);
        await FirebaseFirestore.instance
            .collection('UserData')
            .doc(credential.user!.uid)
            .set({
          'uid': credential.user!.uid,
          'name': name,
          'email': credential.user!.email,
          'image': ''
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      } else {
        return null;
      }
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: 'The password provided is too weak.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(
            msg: 'The Email is Invalid.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    } catch (e) {
      print(e);
    }
  }

  //Sing Out
  Future<void> singOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
