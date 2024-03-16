import 'package:datn/constants/my_icons.dart';
import 'package:datn/global_variable/globals.dart';
import 'package:datn/screens/log_in/log_in.dart';
import 'package:flutter/material.dart';

class SessionTimeoutAlert extends StatelessWidget {
  const SessionTimeoutAlert({super.key});

  @override
  Widget build(BuildContext context) {

    var logoutButton = ElevatedButton.icon(
      onPressed: (){
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) {
            globalLoginResponse = null;
            return const LogIn();
          }), 
          (route) => false
        );
      },
      icon: const Icon(MyIcons.logout),
      label: const Text("Đăng xuất"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0
      )
    );

    return AlertDialog(
      backgroundColor: Colors.white,
      iconColor: Colors.red,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0))
      ),
      titlePadding: const EdgeInsets.fromLTRB(10, 15, 10, 8),
      actionsPadding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      actionsAlignment: MainAxisAlignment.center,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red
            ),
            child: const Icon(
              MyIcons.lockClock, 
              color: Colors.white,
              size: 17,
            ),
          ),
          const SizedBox(width: 5,),
          const Flexible(
            child: Text(
              "Hết phiên hoạt động",
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red
              ),
            ),
          ),
        ],
      ),
      content: const Text(
        "Vui lòng đăng xuất và đăng nhập lại",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13.5,
          color: Color.fromARGB(255, 93, 93, 93)
        ),
      ),
      actions: [
        logoutButton
      ],
    );
  }
  
}