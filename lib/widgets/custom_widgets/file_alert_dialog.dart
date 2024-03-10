import 'package:datn/function/function.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String path;

  const CustomAlertDialog({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {

    var closeButton = TextButton(
      onPressed: (){
        Navigator.of(context).pop();
      }, 
      child: const Text("Đóng")
    );

    var openButton = TextButton(
      onPressed: () async {
        Navigator.of(context).pop();
        
        await FileServices().openFileFromPath(
          context: context, 
          path: path, 
        ).then((value) {
        });
      }, 
      child: const Text("Xem")
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        actionsPadding: const EdgeInsets.all(5),
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
        actions: [
          closeButton,
          openButton
        ],
      ),
    );
  }
}