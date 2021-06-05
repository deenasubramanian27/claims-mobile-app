import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LoginPage.dart';

class AddingPolicy extends StatefulWidget {
  @override
  _AddPolicy createState() => _AddPolicy();
}

class _AddPolicy extends State<AddingPolicy> {
  final _usernameController = TextEditingController();

  StepperType _stpperType = StepperType.vertical;
  String title = 'Add Policy';
  int _currentStep = 0;
  String done = "";
  switchsteptype() => _stpperType == StepperType.vertical
      ? _stpperType = StepperType.horizontal
      : _stpperType = StepperType.vertical;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      // bottomSheet: msg(),
      appBar: AppBar(
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
            child: Text("Log Out"),
            textColor: Colors.white,
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then(
                      (result) => Timer(const Duration(milliseconds: 1000), () {
                            Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          }))
                  // ignore: return_of_invalid_type_from_catch_error
                  .catchError((err) => print(err));
            },
          )
        ],
        backgroundColor: Colors.deepOrange,
        title: Text(title),
        centerTitle: true,
      ),
      body: Theme(
        data: ThemeData(
            accentColor: Colors.orange,
            primarySwatch: Colors.orange,
            colorScheme: ColorScheme.light(primary: Colors.orange)),
        child: Stepper(
          steps: _stepper(),
          physics: ClampingScrollPhysics(),
          currentStep: this._currentStep,
          type: _stpperType,
          onStepTapped: (step) {
            setState(() {
              this._currentStep = step;
            });
          },
          onStepContinue: () {
            setState(() {
              if (this._currentStep < this._stepper().length - 1) {
                this._currentStep = this._currentStep + 1;
              } else {
                //  done = "Policy Added Successfully";
                print('Complete');
                String username = _usernameController.text;
                if (username.isEmpty) {
                  // ignore: deprecated_member_use
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Please fill the details..."),
                    backgroundColor: Colors.orange,
                  ));
                } else {
                  // ignore: deprecated_member_use
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Hello $username . Policy Added Succesfully"),
                    backgroundColor: Colors.orange,
                  ));
                }
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (this._currentStep > 0) {
                this._currentStep = this._currentStep - 1;
              } else {
                this._currentStep = 0;
              }
            });
          },
        ),
      ),

      // floatingActionButton: FloatingActionButton(

      //   onPressed: switchsteptype,
      //   backgroundColor: Colors.deepOrange,
      //   child: Icon(
      //     Icons.swap_horizontal_circle,
      //     color: Colors.white,

      //   ),
      // ),
      // backgroundColor: Colors.deepOrange,
    );
  }

  Widget msg() {
    return SizedBox(
      child: Container(
        width: double.infinity,
        height: 242.0,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
        ),
        child: Center(
          child: Text(
            done,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 25,
              color: Colors.white,
              height: -20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  List<Step> _stepper() {
    List<Step> _steps = [
      Step(
          title: Text(
            'Name',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Lasts Name'),
              )
            ],
          ),
          isActive: _currentStep >= 0,
          state: StepState.complete),
      Step(
          title: Text(
            'Contacts',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email Address'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile Number'),
              )
            ],
          ),
          isActive: _currentStep >= 1,
          state: StepState.disabled),
      Step(
          title: Text(
            'Address',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Primary Address'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'State'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
              )
            ],
          ),
          isActive: _currentStep >= 2,
          state: StepState.disabled),
      Step(
          title: Text(
            'Policy Info',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Policy Type'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Premium Amount'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duration'),
              )
            ],
          ),
          isActive: _currentStep >= 3,
          state: StepState.disabled),
      Step(
          title: Text(
            'Nominee',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile Number'),
              ),
            ],
          ),
          isActive: _currentStep >= 4,
          state: StepState.disabled)
    ];
    return _steps;
  }
}
