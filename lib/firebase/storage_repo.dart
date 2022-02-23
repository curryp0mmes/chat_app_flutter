import 'dart:io';

import 'package:chat_app/firebase/authentication.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepo {
  static FirebaseStorage storage = FirebaseStorage.instance;

  //Upload a file to Firebase and get the DownloadURL
  static Future<String> uploadFile({
    required File file,
    String? subfolder
  }) async {
    Reference ref = storage.ref().child('users').child(AuthenticationTools.getUser()?.uid ?? 'anon');
    if(subfolder != null) ref = ref.child(subfolder);
    ref = ref.child(file.uri.pathSegments.last);

    var task = await ref.putFile(file);

    return task.ref.getDownloadURL();

  }
}