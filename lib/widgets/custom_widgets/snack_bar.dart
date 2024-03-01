import 'package:flutter/material.dart';

class CustomSnackBar {

  void showSnackBar(BuildContext context, {String text = "OK", String errorText = "Lỗi", bool isError = false}) {
    var icon = isError ? Icons.error_outline_outlined : Icons.check_circle_outline_outlined;
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
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}