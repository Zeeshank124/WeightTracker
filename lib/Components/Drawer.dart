import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weighttracker/Screens/LoginScreen.dart';

class FrostedDrawer extends StatefulWidget {
  @override
  _FrostedDrawerState createState() => _FrostedDrawerState();
}

class _FrostedDrawerState extends State<FrostedDrawer> {
  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: double.infinity,
      decoration: BoxDecoration(
          color: Color.fromARGB(180, 250, 250, 250),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(31, 38, 135, 0.4),
              blurRadius: 8.0,
            )
          ],
          border: Border(
              right: BorderSide(
            color: Colors.white70,
          ))),
      child: Stack(
        children: [
          SizedBox(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4.0,
                  sigmaY: 4.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.green.withOpacity(0.8),
                  ])),
                ),
              ),
            ),
          ),
          Column(
            children: [
              DrawerHeader(
                child: Row(
                  children: [
                    Text(
                      "${user!.email} ",
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () {
                        logout(context);
                      },
                      leading: Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      title: Text("Log Out"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
