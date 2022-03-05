// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/model/user_model.dart';
import 'package:habit_tracker_application_main/provider/firebase_services.dart';
import 'package:habit_tracker_application_main/services/firebase_auth.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';

import 'package:habit_tracker_application_main/utilitis/loading.dart';
import 'package:habit_tracker_application_main/widgets/buttons.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import '../profile_edit_screen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthServices>(context);
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Loading()
            : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('UserData')
                    .doc(user!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something Went Wrong'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 110,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileEdit(
                                    currentName: data['name'],
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 85,
                                  width: 85,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(data['image']),
                                          fit: BoxFit.cover)),
                                  child: data['image'] == null
                                      ? const Center(
                                          child: Icon(
                                            Icons.image,
                                            color: kFullGreenColor,
                                          ),
                                        )
                                      : Container(),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.edit,
                                        color: kFullGreenColor,
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(child: Text('${data['name']}')),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(child: Text(data['email'])),
                          ),
                          const SizedBox(
                            height: 60,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Divider(),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await _auth.singOut();
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Container(
                              height: 50,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.all(10),
                              width: 50,
                              decoration: BoxDecoration(
                                  color: kFullGreenColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child:
                                  const Center(child: Icon(Icons.exit_to_app)),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Loading();
                  }
                }),
      ),
    );
  }
}
