import 'package:chat_app/firebase/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHandler {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static UserData? currentUser;

  static Future<UserData> getUserData({required String? uid}) async {
    var userData = await firestore.collection("users").doc(uid ?? "anon").get();

    var email = userData.get("email");
    var displayName = userData.get("displayName");
    var photoURL = userData.get("photoURL");


    return UserData(uid: uid ?? "anon", email: email, displayName: displayName, photoURL: photoURL);
  }

  static void updateValue({required String uid, required String path, required value}) {
    var userCollection = firestore.collection("users");
    var document = userCollection.doc(uid);
    document.update({path: value});
  }

  static void createUser({required String uid, required String email}) {
    var userCollection = firestore.collection("users");

    userCollection.doc(uid)
        .set({'displayName': null, 'email': email, 'photoURL': null});
  }

  static Future<void> setupDatabase() async {
    if(AuthenticationTools.isSignedIn()) {
      String uid = AuthenticationTools.getUser()?.uid ?? "anon";
      String email = AuthenticationTools.getUser()?.email ?? "no email given";
      if(!(await _userExists(uid))) {
        createUser(uid: uid, email: email);
      }
      currentUser = await getUserData(uid: uid);
      return;
    }
    else {
      currentUser = null;
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
    print("update");
    DatabaseHandler.updateValue(uid: uid, path: "photoURL", value: newURL);
    photoURL = newURL;
    return newURL;
  }
}