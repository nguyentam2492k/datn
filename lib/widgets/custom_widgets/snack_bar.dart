import 'package:datn/constants/my_icons.dart';
import 'package:datn/global_variable/globals.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {

  void showSnackBar({String text = "OK", String errorText = "Lỗi", bool isError = false}) {
    var icon = isError ? MyIcons.error : MyIcons.check;
    var color = isError ? Colors.red : Colors.green;
    var snackBarText = isError ? errorText : text;

    var snackBar = SnackBar(
      content: Row(
        children: [

          Icon(icon, color: color,),
          const SizedBox(width: 10,),
          Expanded(child: Text(snackBarText)),
        ],
      ),
      showCloseIcon: true,
    );
    rootScaffoldMessengerKey.currentState!.showSnackBar(snackBar);
  }
}