import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movieish/backend/sharedpreferences.dart';
import 'package:movieish/backend/users.dart';
import 'package:movieish/screens/home.dart';

class AuthenticationMethods {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Users _users(FirebaseUser user){
    return user!=null ? Users(userId: user.uid) : null;
  }

  Future signInWithEAndP(String email, String password) async{
    try{
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _users(firebaseUser);
    } catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEAndP(String mail, String password) async {
    try{
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword
        (email: mail, password: password);
      FirebaseUser firebaseUser = result.user;
      return _users(firebaseUser);
    } catch(e){
      print(e.toString());
    }
  }

  Future<FirebaseUser> signInUsingGoogle(BuildContext context) async{
    final GoogleSignIn signIn = new GoogleSignIn();
    final GoogleSignInAccount signInAccount = await signIn.signIn();
    final GoogleSignInAuthentication signInAuthentication = await
    signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken);

    AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);

    FirebaseUser userData = authResult.user;

    if(authResult != null){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomeScreen()
      ));
    }

    return userData;
  }

  Future resetPassword(String mail) async{
    try{
      return await _firebaseAuth.sendPasswordResetEmail(email: mail);
    } catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      SharedPreferencesFunctions.saveUserLogInState(false);
      return _firebaseAuth.signOut();
    } catch(e){
      print(e.toString());
    }
  }

}