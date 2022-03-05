import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/provider/database_provider.dart';
import 'package:habit_tracker_application_main/screens/splash_screen/splash_screen.dart';
import 'package:habit_tracker_application_main/services/firebase_auth.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthServices>(create: (context) => AuthServices()),
        Provider<DataBaseProvider>(create: (context) => DataBaseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'habit-tracker-application-main',
        theme: ThemeData(
          primarySwatch: kcolor,
          primaryColor: kFullGreenColor,
        ),
        home: SpalshScreenPage(),
      ),
    );
  }
}
