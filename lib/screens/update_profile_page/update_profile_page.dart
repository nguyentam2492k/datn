import 'package:datn/widgets/create_request/request_18.dart';
import 'package:flutter/material.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return UpdateProfilePageState();
  }
  
}

class UpdateProfilePageState extends State<UpdateProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.3,
          )
        ),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        title: const Text(
          "Cập nhật hồ sơ"
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 8),
        child: Request18(),
      ),
    );
  }
  
}