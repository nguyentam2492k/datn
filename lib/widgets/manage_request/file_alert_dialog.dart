import 'package:datn/function/function.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

Widget fileAlertDialog({required BuildContext parentContext, required BuildContext alertContext, required String url, required String path}) {

  var closeButton = TextButton(
    onPressed: (){
      Navigator.of(alertContext).pop();
    }, 
    child: const Text("Đóng")
  );

  var openButton = TextButton(
    onPressed: () async {
      Navigator.of(alertContext).pop();
      parentContext.loaderOverlay.show(progress: "Đang mở");
      
      await FileServices().openFileFromPath(
        context: parentContext, 
        path: path, 
      ).then((value) {
        parentContext.loaderOverlay.hide();
      });
    }, 
    child: const Text("Xem")
  );

  return AlertDialog(
    backgroundColor: Colors.white,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0))
    ),
    titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    title: const Text(
      "Tải xong",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Tên tệp: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(text: getFileNameFromUrl(path), style: const TextStyle(color: Colors.black)),
            ]
          )
        ),
        const SizedBox(height: 5,),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Đường dẫn: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              TextSpan(text: path, style: const TextStyle(color: Colors.black)),
            ]
          )
        )
      ]
    ),
    actionsPadding: const EdgeInsets.all(5),
    actions: [
      closeButton,
      openButton
    ],
  );
}