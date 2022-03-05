import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/model/user_model.dart';

import 'package:habit_tracker_application_main/screens/login_and_register/login_page.dart';
import 'package:habit_tracker_application_main/screens/main_screen/main_screen.dart';
import 'package:habit_tracker_application_main/services/firebase_auth.dart';
import 'package:habit_tracker_application_main/utilitis/loading.dart';
import 'package:provider/provider.dart';

class WrapperScreen extends StatelessWidget {
  const WrapperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthServices>(context);
    return StreamBuilder<User?>(
        stream: _auth.user,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            return user == null ? LoginPage() : const MainScreen();
          } else {
            return Scaffold(
              body: Center(
                child: Loading(),
              ),
            );
          }
        });
  }
}
