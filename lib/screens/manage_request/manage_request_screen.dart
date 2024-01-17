import 'package:flutter/material.dart';

class ManageRequestScreen extends StatefulWidget {
  const ManageRequestScreen({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return ManageRequestScreenState();
  }
}

class ManageRequestScreenState extends State<ManageRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Xử lý yêu cầu"),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        body: Container(
          color: Colors.red,
        ),
      ),
    );
  }
}