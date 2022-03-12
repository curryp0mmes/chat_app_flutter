import 'package:flutter/material.dart';

class Constants {

  static String emptyProfilePic = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
  static String emptyProfilePicAsset = 'assets/blank-profile-picture.png';

  static InputDecoration getLoginFormInputDecoration({required labelText}) {
    return InputDecoration(border: const OutlineInputBorder(), labelText: labelText);
  }
}
