import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SubmitClaim extends StatefulWidget {
  File image;
  SubmitClaim(this.image);

  @override
  Claim createState() => Claim(image);
}

class Claim extends State<SubmitClaim> {
  String map;
  File image;
  Claim(this.image);
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.deepOrange,
        child: Column(
          children: [
            SafeArea(
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(.0),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(width: 3.0, color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    image: DecorationImage(
                        alignment: Alignment.center,
                        image: FileImage(image),
                        fit: BoxFit.cover)),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(5),
                    color: Colors.black.withOpacity(0.3),
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        "Damaged Vecile",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Text("data$map"),
            ),
            Container(
              margin: const EdgeInsets.all(40.0),
              padding: const EdgeInsets.all(6.0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                onPressed: () {
                  showData();
                },
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Upload File',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange,
                        ),
                      ),
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.orange,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future<void> showData() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('policy')
        .doc('TApzyJmtO1qZjbIU3Hsb')
        .snapshots()
        .listen((event) {
      setState(() {
        map = event.get("Name");
      });
    });
  }
}
