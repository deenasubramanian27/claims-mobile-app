import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'BottomNavBar.dart';
import 'btn_widget.dart';
import 'herder_container.dart';
import 'regi_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  bool _passwordVisible = true;

  @override
  initState() {
    _passwordVisible = true;
    emailInputController = new TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Login"),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 20, right: 20, top: 50),
                child: SingleChildScrollView(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 15),
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
                          margin: EdgeInsets.only(top: 15),
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
                            validator: pwdValidator,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        // _textInput(
                        //     controller: emailInputController,
                        //     hint: "Email",
                        //     icon: Icons.email,
                        //     value: emailInputController.text),
                        // _textInput(
                        //     controller: pwdInputController,
                        //     hint: "Password",
                        //     icon: Icons.vpn_key),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.all(60),
                          child: Center(
                            child: ButtonWidget(
                              onClick: () {
                                if (_loginFormKey.currentState.validate()) {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: emailInputController.text,
                                          password: pwdInputController.text)
                                      .then((currentUser) => FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .doc(currentUser.user.uid)
                                          .get()
                                          .then((DocumentSnapshot result) =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BottomNavBar(
                                                            title: result[
                                                                    "fullname"] +
                                                                "'s Tasks",
                                                            uid: currentUser
                                                                .user.uid,
                                                          ))))
                                          .catchError((err) => print(err)))
                                      .catchError((err) => print(err));
                                }
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => BottomNavBar()));
                              },
                              btnText: "LOGIN",
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't haveaccount ?"),
                              // ignore: deprecated_member_use
                              FlatButton(
                                child: Text("Register"),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegPage()));
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

  // Widget _textInput({controller, hint, icon, value}) {
  //   return Container(
  //     margin: EdgeInsets.only(top: 15),
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
