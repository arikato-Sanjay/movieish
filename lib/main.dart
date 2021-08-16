import 'package:flutter/material.dart';
import 'package:movieish/screens/home.dart';
import 'package:movieish/screens/login/login_swithcer.dart';
import 'package:movieish/themes/colors_theme.dart';
import 'backend/sharedpreferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    print(isUserLoggedIn);
    await SharedPreferencesFunctions.getUserLogInState().then((value) {
      setState(() {
        isUserLoggedIn = value;
        print(isUserLoggedIn);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movieish',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        accentColor: ColorsTheme.yellow1,
        primaryColor: ColorsTheme.yellow2,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isUserLoggedIn != null
          ? isUserLoggedIn ? HomeScreen() : LoginSwitcher()
          : Container(
              child: Center(
                child: LoginSwitcher(),
              ),
            ),
    );
  }
}
