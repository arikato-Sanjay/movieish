import 'package:flutter/material.dart';
import 'package:movieish/screens/login/signin.dart';
import 'package:movieish/screens/login/signup.dart';

class LoginSwitcher extends StatefulWidget {
  @override
  _LoginSwitcherState createState() => _LoginSwitcherState();
}

class _LoginSwitcherState extends State<LoginSwitcher> {
  bool signIn = true;

  @override
  Widget build(BuildContext context) {
    if (signIn) {
      return SignIn(switchScreen);
    } else {
      return SignUp(switchScreen);
    }
  }

  void switchScreen() {
    setState(() {
      signIn = !signIn;
    });
  }
}
