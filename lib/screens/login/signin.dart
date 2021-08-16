import 'package:flutter/material.dart';
import 'package:movieish/backend/authentication.dart';
import 'package:movieish/backend/sharedpreferences.dart';
import 'package:movieish/screens/home.dart';
import 'package:movieish/screens/loading/loading_screen.dart';

class SignIn extends StatefulWidget {
  final Function switcher;

  SignIn(this.switcher);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  AuthenticationMethods authenticationMethods = new AuthenticationMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movieish"),
      ),
      body: isLoading
          ? Center(child: LoadingScreen())
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                                controller: emailTEC,
                                validator: (input) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(input)
                                      ? null
                                      : "Enter valid mailId";
                                },
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: "Enter email-Id",
                                  labelStyle: new TextStyle(
                                    color: Colors.black,
                                  ),
                                  enabledBorder: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                )),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                                controller: passwordTEC,
                                obscureText: true,
                                validator: (input) {
                                  return input.isEmpty || input.length < 6
                                      ? "Please Enter Password"
                                      : null;
                                },
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: "Enter Password",
                                  labelStyle: new TextStyle(
                                    color: Colors.black,
                                  ),
                                  enabledBorder: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          //forgetPassword();
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              child: Text(
                                "Forgot Password:(",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 22),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5),
                              gradient: LinearGradient(colors: [
                                const Color(0xffFDEB71),
                                const Color(0xffF8D800)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          AuthenticationMethods().signInUsingGoogle(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 22),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5),
                              gradient: LinearGradient(colors: [
                                const Color(0xffF8D800),
                                const Color(0xffFDEB71)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign In with Google",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "New to Movieish? ",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.switcher();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Register now",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  signIn() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authenticationMethods
          .signInWithEAndP(emailTEC.text, passwordTEC.text)
          .then((value) {
        if (value != null) {
          SharedPreferencesFunctions.saveUserLogInState(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      });
    }
  }

  forgetPassword() {
    if (emailTEC.text.isNotEmpty) {
      authenticationMethods.resetPassword(emailTEC.text).then((value) {
        SnackBar(
          content: Text("Password Reset Link has been sent"),
        );
        print("link sent");
      });
    } else {
      SnackBar(
        content: Text("Email field can't be empty"),
      );
    }
  }
}
