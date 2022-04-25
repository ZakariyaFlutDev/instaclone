import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/services/prefs_service.dart';

import '../pages/signin_page.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;



  //SIGN UP METHOD
  static Future signUp({required String email, required String password}) async {
    Map<String, User?> map = new Map();
    try {
      User? firebaseUser = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user;
      map.addAll({"SUCCESS" : firebaseUser});
    } on FirebaseAuthException catch (error) {
      print(error);
      switch(error.code){
        case "ERROR_EMAIL_ALREADY_IN_USE":
          map.addAll({"ERROR_EMAIL_ALREADY_IN_USE": null});
          break;
        default :
          map.addAll({"ERROR" : null});
      }
    }
    return map;
  }

  //SIGN IN METHOD
  static Future signIn({required String email, required String password}) async {
    Map<String, User?> map = {};
    try {
      User? firebaseUser = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
      print(firebaseUser.toString());
      map.addAll({"SUCCESS" : firebaseUser});
    } on FirebaseAuthException catch (e) {
      print(e);
      map.addAll({"ERROR": null});
    }
    return map;
  }

  //SIGN OUT METHOD
  static Future signOut(BuildContext context) async {
    await _auth.signOut();
    // Write Prefs removeUserId
    Prefs.removeUserId().then((value) => {
      Navigator.pushReplacementNamed(context, SignInPage.id),
    });

    print('signout');
  }
}