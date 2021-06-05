import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'BottomNavBar.dart';

import 'color.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Timer(const Duration(milliseconds: 4000), () {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => LoginPage()));
    // });
    Firebase.initializeApp();
    User currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Timer(const Duration(milliseconds: 4000), () {
        Navigator.pushReplacementNamed(context, "/login");
      });
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get()
          .then((DocumentSnapshot result) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNavBar(
                        title: result["fullname"] + "'s Tasks",
                        uid: currentUser.uid,
                      ))))
          .catchError((err) => print(err));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [orangeColors, orangeLightColors],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
        ),
        child: Center(
          child: Image.asset("images/logo.png"),
        ),
      ),
    );
  }
}
