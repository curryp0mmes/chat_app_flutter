import 'dart:convert';
import 'dart:math';

import 'package:mkship_app/firebase/authentication.dart';
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

  static Future<List<String>> getUserChats({required String? uid}) async {
    var userData = await firestore.collection("users").doc(uid ?? "anon").get();
    var chats;
    try {
      chats = userData.get("chats");
    } on StateError {
      return List<String>.empty();
    }
    List<String> chatids = (chats as List<dynamic>).cast<String>();
    return chatids;
  }

  static Future<Map<String, dynamic>> getChatInfo(String chatid) async {
    var chatData = await firestore.collection("chats").doc(chatid).get();
    if(chatData.data() == null) return jsonDecode('{"error":"nodata"}');

    Map<String, dynamic> chatJSON = chatData.data()!;
    if(chatJSON["members"] != null) {
      List<dynamic> uids = chatJSON["members"] as List<dynamic>;
      for(int i = 0; i < uids.length; i++) {
        var userData = await firestore.collection("users").doc(uids[i]).get();
        Map<String, dynamic> user = userData.data()!;
        user.update("uid", (value) => uids[i], ifAbsent: () => uids[i]);
        uids[i] = user;
      }
    }
    return chatJSON;
  }

  static dynamic getLiveChatMessages(String chatID) {
    var chat = firestore.collection("chats").doc(chatID).collection("messages").orderBy("timestamp").snapshots();
    return chat;
  }

  static void sendChatMessage(String chatID, String message) {
    var newMessage = <String, dynamic>{
      "messageText": message,
      "from": AuthenticationTools.getUser()?.uid,
      "timestamp": Timestamp.now()
    };
    firestore.collection("chats").doc(chatID).collection("messages").add(newMessage);
  }

  static Future<UserData> getRandomUser({List<String>? excludedUIDs}) async {
    var users = firestore.collection("users");
    QuerySnapshot collection = await users.get();
    QueryDocumentSnapshot user;
    do {
      //TODO gotta fix that awful query
      var index = Random().nextInt(collection.docs.length);
      user = collection.docs[index];
    } while (excludedUIDs != null && excludedUIDs.contains(user.id));
    return await getUserData(uid: user.id);
  }
  static Future<List<UserData>> getAllUsers() async {
    var users = firestore.collection("users");
    QuerySnapshot collection = await users.get();
    List<UserData> output = List<UserData>.empty(growable: true);
    for(int i = 0; i < collection.docs.length; i++) {
      output.add(await getUserData(uid: collection.docs[i].id));
    }

    return output;
  }

  static void updateUserValue({required String uid, required String path, required value}) {
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

class ChatData {
  String chatID;
  String? chatName;
  List<Map<String, dynamic>>? messages;
  List<UserData> members;

  ChatData({required this.chatID, required this.members, this.chatName, this.messages});
}

class UserData {
  String uid;
  String? photoURL;
  String? email;
  String? displayName;
  String? bio;


  UserData({required this.uid, this.photoURL, this.email, this.bio, this.displayName});

  String updatePhotoURL(String newURL) {
    DatabaseHandler.updateUserValue(uid: uid, path: "photoURL", value: newURL);
    photoURL = newURL;
    return newURL;
  }
  String updateDisplayName(String newName) {
    DatabaseHandler.updateUserValue(uid: uid, path: "displayName", value: newName);
    displayName = newName;
    return newName;
  }
}