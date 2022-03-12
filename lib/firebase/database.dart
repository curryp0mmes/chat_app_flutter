import 'package:chat_app/firebase/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHandler {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static UserData? currentUser;

  static Future<UserData> getUserData({required String? uid}) async {
    var userData = await firestore.collection("users").doc(uid ?? "anon").get();

    return UserData(uid: uid ?? "anon", email: userData.get("email"));
  }

  static void updateValue({required String uid, required String path, required value}) {
    var userCollection = firestore.collection("users");

    userCollection.doc(uid)
        .update({path: value});
  }

  static void createUser({required String uid}) {
    var userCollection = firestore.collection("users");

    userCollection.doc(uid)
        .set({'displayName': 'ABC', 'age': 20});
  }

  static void setupDatabase() async {
    if(AuthenticationTools.isSignedIn()) {
      String uid = AuthenticationTools.getUser()?.uid ?? "anon";
      if(!(await _userExists(uid))) {
        createUser(uid: uid);
      }
      currentUser = await getUserData(uid: uid);
    }
  }

  static Future<bool> _userExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = firestore.collection('users');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

}

class UserData {
  String uid;
  String? photoURL;
  String? email;
  String? displayName;
  String? bio;


  UserData({required this.uid, this.photoURL, this.email, this.bio, this.displayName});

  String updatePhotoURL(String newURL) {
    DatabaseHandler.updateValue(uid: uid, path: "photoURL", value: newURL);
    return newURL;
  }
}