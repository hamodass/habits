import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  CollectionReference userData =
      FirebaseFirestore.instance.collection('UserData');


  Future<void> saveUser(
      {CollectionReference? reference,
      Map<String, dynamic>? data,
      }) {
    return reference!.doc().set(data);
  }
}