import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/LoginPage.dart';
import 'BottomNavBar.dart';
import 'btn_widget.dart';
//import 'color.dart';
import 'herder_container.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController emailInputController;
  TextEditingController phoneInputController;
  TextEditingController pwdInputController;
  bool _passwordVisible = true;

  @override
  initState() {
    _passwordVisible = true;
    firstNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    phoneInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Register"),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _registerFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            controller: firstNameInputController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Fullname",
                              prefixIcon: Icon(Icons.person),
                            ),
                            onEditingComplete: () => {node.nextFocus()},
                            // ignore: missing_return
                            validator: (value) {
                              if (value.length < 3) {
                                return "Please enter a valid name.";
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailInputController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                            onEditingComplete: () => {node.nextFocus()},
                            validator: emailValidator,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: phoneInputController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone",
                              prefixIcon: Icon(Icons.call),
                            ),
                            onEditingComplete: () => {node.nextFocus()},
                            validator: validateMobile,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _passwordVisible,
                            controller: pwdInputController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              prefixIcon: Icon(Icons.vpn_key),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility_rounded,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            onEditingComplete: () => {node.nextFocus()},
                            validator: pwdValidator,
                          ),
                        ),

                        // _textInput(
                        //     controller: firstNameInputController,
                        //     hint: "Fullname",
                        //     icon: Icons.person),
                        // _textInput(
                        //     controller: emailInputController,
                        //     hint: "Email",
                        //     icon: Icons.email),
                        // _textInput(
                        //     controller: phoneInputController,
                        //     hint: "Phone Number",
                        //     icon: Icons.call),
                        // _textInput(
                        //     controller: pwdInputController,
                        //     hint: "Password",
                        //     icon: Icons.vpn_key),
                        Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.all(50),
                          child: Center(
                            child: ButtonWidget(
                              btnText: "REGISTER",
                              onClick: () {
                                if (_registerFormKey.currentState.validate()) {
                                  // if (pwdInputController.text ==
                                  //     confirmPwdInputController.text) {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: emailInputController.text,
                                          password: pwdInputController.text)
                                      .then((currentUser) => FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .doc(currentUser.user.uid)
                                          .set({
                                            "uid": currentUser.user.uid,
                                            "fullname":
                                                firstNameInputController.text,
                                            "phone": phoneInputController.text,
                                            "email": emailInputController.text,
                                          })
                                          .then((result) => {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BottomNavBar(
                                                              title:
                                                                  firstNameInputController
                                                                          .text +
                                                                      "'s Tasks",
                                                              uid: currentUser
                                                                  .user.uid,
                                                            )),
                                                    (_) => false),
                                                firstNameInputController
                                                    .clear(),
                                                emailInputController.clear(),
                                                pwdInputController.clear(),
                                                phoneInputController.clear(),
                                              })
                                          // ignore: return_of_invalid_type_from_catch_error
                                          .catchError((err) => print(err)))
                                      // ignore: return_of_invalid_type_from_catch_error
                                      .catchError((err) => print(err));
                                  // } else {
                                  //   showDialog(
                                  //       context: context,
                                  //       builder: (BuildContext context) {
                                  //         return AlertDialog(
                                  //           title: Text("Error"),
                                  //           content: Text(
                                  //               "The passwords do not match"),
                                  //           actions: <Widget>[
                                  //             // ignore: deprecated_member_use
                                  //             FlatButton(
                                  //               child: Text("Close"),
                                  //               onPressed: () {
                                  //                 Navigator.of(context).pop();
                                  //               },
                                  //             )
                                  //           ],
                                  //         );
                                  //       });
                                  // }
                                }
                              },
                              //Navigator.pop(context);
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already a member ?"),
                              // ignore: deprecated_member_use
                              FlatButton(
                                child: Text("Login"),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget _textInput({controller, hint, icon}) {
  //   return Container(
  //     margin: EdgeInsets.only(top: 20),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(20)),
  //       color: Colors.white,
  //     ),
  //     padding: EdgeInsets.only(left: 10),
  //     child: TextFormField(
  //       controller: controller,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: hint,
  //         prefixIcon: Icon(icon),
  //       ),
  //       onFieldSubmitted: (value) {
  //         FocusScope.of(context).unfocus();
  //       },
  //     ),
  //   );
  // }
}
