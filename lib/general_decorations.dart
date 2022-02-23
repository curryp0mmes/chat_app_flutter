import 'package:flutter/material.dart';

class CommonDecorations {

  static InputDecoration getLoginFormInputDecoration({required labelText}) {
    return InputDecoration(border: const OutlineInputBorder(), labelText: labelText);
  }
}
