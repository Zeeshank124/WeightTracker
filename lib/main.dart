import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weighttracker/Screens/LoginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Tracker',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryTextTheme: TextTheme(
              bodyText1: TextStyle(
                  fontFamily: "Times New Roman",
                  color: Colors.green,
                  fontSize: 30))),
      home: LoginScreen(),
    );
  }
}
