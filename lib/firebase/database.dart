import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseHandler {
  static FirebaseDatabase database = FirebaseDatabase.instance;

  static void getUserData({required String username}) {
    DatabaseReference ref = database.ref("users/$username");
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print(data);
    });
  }
}