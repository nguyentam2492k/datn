import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/my_icons.dart';
import 'package:datn/widgets/create_request/request_1.dart';
import 'package:datn/widgets/create_request/request_10.dart';
import 'package:datn/widgets/create_request/request_11.dart';
import 'package:datn/widgets/create_request/request_12.dart';
import 'package:datn/widgets/create_request/request_13.dart';
import 'package:datn/widgets/create_request/request_14.dart';
import 'package:datn/widgets/create_request/request_15.dart';
import 'package:datn/widgets/create_request/request_16.dart';
import 'package:datn/widgets/create_request/request_17.dart';
import 'package:datn/widgets/create_request/request_18.dart';
import 'package:datn/widgets/create_request/request_19.dart';
import 'package:datn/widgets/create_request/request_2.dart';
import 'package:datn/widgets/create_request/request_20.dart';
import 'package:datn/widgets/create_request/request_21.dart';
import 'package:datn/widgets/create_request/request_22.dart';
import 'package:datn/widgets/create_request/request_3.dart';
import 'package:datn/widgets/create_request/request_4.dart';
import 'package:datn/widgets/create_request/request_5.dart';
import 'package:datn/widgets/create_request/request_6.dart';
import 'package:datn/widgets/create_request/request_7.dart';
import 'package:datn/widgets/create_request/request_8.dart';
import 'package:datn/widgets/create_request/request_9.dart';
import 'package:datn/widgets/create_request/welcome.dart';
import 'package:datn/widgets/custom_widgets/bottom_sheet_with_list.dart';
import 'package:flutter/material.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return CreateRequestScreenState();
  }

}

class CreateRequestScreenState extends State<CreateRequestScreen> {

  final List<Widget> requestWidgets = [
    const Request1(),
    const Request2(),
    const Request3(),
    const Request4(),
    const Request5(),
    const Request6(),
    const Request7(),
    const Request8(),
    const Request9(),
    const Request10(),
    const Request11(),
    const Request12(),
    const Request13(),
    const Request14(),
    const Request15(),
    const Request16(),
    const Request17(),
    const Request18(),
    const Request19(),
    const Request20(),
    const Request21(),
    const Request22(),
  ];
  late String? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: createRequestScreenBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Tạo yêu cầu"),
      centerTitle: true,
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      shape: const Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.3,
        )
      ),
    );
  }

  Widget createRequestScreenBody() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          chooseRequestWidget(),
          Expanded(
            child: requestWidget(),
          )
        ],
      ),
    );
  }

  Container chooseRequestWidget() {
    return Container(
          color: Colors.white,
          height: 50,
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              const Expanded(
                flex: 1,
                child: Text(
                  "Yêu cầu:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: ElevatedButton.icon(
                  
                  icon: const Icon(MyIcons.arrowDown),
                  label: Text(selectedItem ?? "Chọn yêu cầu"),
                  onPressed: () async {
                    final String? data = await openBottomSheet(selectedItem);
                    if (data != null) {
                      setState(() {
                        selectedItem = data;
                      });
                    }
                    
                  },
                ),
              )
            ],
          ),
        );
  }
  Column requestWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 0.3,
          color: Colors.grey,
        ),
        Expanded(
          child: Builder(builder: (BuildContext context) {
            if (selectedItem != null) {
              int index = ConstantList.requests.indexOf(selectedItem!);
              return requestWidgets[index];
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: welcomeCreateRequest(),
              );
            }
          },),
        ),
      ],
    );
  }

  Future<dynamic> openBottomSheet(String? selectedItem) {
    String? selectedItemChanged = selectedItem;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      builder: (context) {
        return BottomSheetWithList(
          title: "Yêu cầu",
          list: ConstantList.requests,
          selectedItem: selectedItemChanged,
        );
      },
    );
  }
}