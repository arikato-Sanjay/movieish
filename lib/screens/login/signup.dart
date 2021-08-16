import 'package:flutter/material.dart';
import 'package:movieish/backend/authentication.dart';
import 'package:movieish/backend/sharedpreferences.dart';
import 'package:movieish/screens/home.dart';

class SignUp extends StatefulWidget {
  final Function switcher;

  SignUp(this.switcher);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTEC = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  AuthenticationMethods authenticationMethods = new AuthenticationMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movieish"),
      ),
      body: loading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                                controller: usernameTEC,
                                validator: (input) {
                                  return input.isEmpty || input.length < 3
                                      ? "Username too short"
                                      : null;
                                },
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: "Enter Username",
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
                        height: 14,
                      ),
                      GestureDetector(
                        onTap: () {
                          signUpNow();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 22),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black, width: 0.5
                              ),
                              gradient: LinearGradient(colors: [
                                const Color(0xffFDEB71),
                                const Color(0xffF8D800)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already a member? ",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.switcher();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "SignIn now",
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
                    ], // <Widget>[]
                  ),
                ),
              ),
            ),
    );
  }

  signUpNow() {
    if (formKey.currentState.validate()) {
      SharedPreferencesFunctions.saveUserName(usernameTEC.text);
      SharedPreferencesFunctions.saveUserEmail(emailTEC.text);

      setState(() {
        loading = true;
      });

      authenticationMethods
          .signUpWithEAndP(emailTEC.text, passwordTEC.text)
          .then((e) {
        //print("$e");
        SharedPreferencesFunctions.saveUserLogInState(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }
  }
}
