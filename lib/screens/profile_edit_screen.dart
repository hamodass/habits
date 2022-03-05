import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:habit_tracker_application_main/provider/firebase_services.dart';
import 'package:habit_tracker_application_main/screens/main%20screens/overview_screen.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:habit_tracker_application_main/utilitis/loading.dart';
import 'login_and_register/widget/form_field.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  bool isVisible = false;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // File _image;
  final controller = TextEditingController();
  String? name;
  dynamic image;
  String? fileName;
  //Firebase Services Instance
  final FirebaseServices _firebaseServices = FirebaseServices();

  //Image Picker Function
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    } else {
      // ignore: avoid_print
      print('User Canceld Image');
    }
  }

  //Save Image TO Firebase Storage
  saveImageToFirebaseDB() async {
    // var ref = firebase_storage.FirebaseStorage.instance
    //     .ref('CategoryImages/$fileName');

    try {
      FirebaseFirestore.instance.collection('UserData').doc(user!.uid).update({
        // 'image': value,
        'name': controller.text
      });
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
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
              return isLoading
                  ? Loading()
                  : SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            GestureDetector(
                              // onTap: pickImage,
                              child: Container(
                                height: 85,
                                width: 85,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    color: kFullGreenColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(data['email']),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: FormWidget(
                                onTap: () {},
                                controller: controller,
                                lableText: data['name'] ?? 'Name',
                                validator: (val) =>
                                    val.isEmpty ? 'Enter Your Name' : null,
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    await saveImageToFirebaseDB();
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                  return;
                                },
                                child: const Text(
                                  'Apply Changes',
                                  style: TextStyle(color: kBlack54),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            OutlinedButton(
                                onPressed: () async {},
                                child: const Text('Change Password')),
                          ],
                        ),
                      ),
                    );
            } else {
              return Loading();
            }
          }),
    );
  }

  Widget mainButtonWidget(String? title, Color? color, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(title!)),
      ),
    );
  }
}

// Future getImage() async {
//   var image = await ImagePicker.pickImage(source: ImageSouece.gallery);
//   setState(() {
//     _image = image;
//   });
// }
