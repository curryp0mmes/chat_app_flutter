import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationTools {
  static void setupAuth() {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.userChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        BuildContext? context = navigatorKey.currentContext;
        if(context != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      } else {
        print('User is signed in!');
        BuildContext? context = navigatorKey.currentContext;
        if(context != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePageScreen()));
        }
      }
    });
  }

  static bool isSignedIn() {
    User? user = FirebaseAuth.instance.currentUser;

    return user != null;
  }

  static void signIn(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      else {
        print(e.code);
      }
    }
  }

  static void register(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout() async {
    try {
      FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  static User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}