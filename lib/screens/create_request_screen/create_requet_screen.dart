import 'package:flutter/material.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return CreateRequestScreenState();
  }

}

class CreateRequestScreenState extends State<CreateRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        body: createRequestScreenBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Tao yeu cau"),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold
      ),
      elevation: 0,
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.3,
        )
      ),
    );
  }

  Widget createRequestScreenBody() {
    return Container(
      color: Colors.amber,
    );
  }
}