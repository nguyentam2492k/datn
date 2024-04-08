import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyToast {

  static void showToast({String text = "OK", String errorText = "Lỗi", bool isError = false}) {
    var color = isError ? Colors.red : Colors.green;
    var toastText = isError ? errorText : text;

    Fluttertoast.showToast(
      msg: toastText,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      textColor: Colors.white,
      fontSize: 14.0,
      backgroundColor: color
    );
  }
}