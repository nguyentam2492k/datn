import 'dart:convert';
import 'dart:io';

import 'package:datn/api/api_service.dart';
import 'package:datn/constants/constant_list.dart';
import 'package:datn/widgets/manage_request/request_information_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ManageRequestScreen extends StatefulWidget {
  const ManageRequestScreen({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return ManageRequestScreenState();
  }
}

class ManageRequestScreenState extends State<ManageRequestScreen> {

  APIService apiService = APIService();
  List<MyData> listRequest = List.empty();
  
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = ConstantList.requestStatus[0];
  }

  @override
  Widget build(BuildContext context) {
    apiService.getData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: manageRequestScreenBody(ConstantList.requestStatus, selectedStatus),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Xử lý yêu cầu"),
      centerTitle: true,
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold
      ),
      elevation: 0,
      shape: const Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.3,
        )
      ),
    );
  }

  Widget manageRequestScreenBody(List<String> listStatus, String? selectedStatus) {

    //Random color for test
    List myColors = [Colors.red, Colors.green, Colors.orangeAccent];
    List<Color> colors = [];
    for(int i=0; i < 20; i++) {
      colors.add(myColors[Random().nextInt(3)]);
    }
    
    return Stack(
      children: [
        buildRequestListView(colors),

        Align(
          alignment: Alignment.topRight,
          child: buildFilterButton(selectedStatus),
        ),
      ]
    );
  }

  Color getColor(String status) {
    switch (status) {
      case "Đã xong":
        return Colors.green;
      case "Đã huỷ":
        return Colors.red;
      case "Đang xử lý":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  //NOTE: CHECK WHETHER STRING IS INTEGER OR NOT
  bool isInteger(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  Future<String> fileToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<File> imageToFile() async {
    ByteData bytes = await rootBundle.load('assets/images/uet.png');
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/image.jpg');
    await file.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes)
    );
    return file;
  }

  void postData(String lastestId) {
    // Image image = Image.asset("assets/images/avatar.jpg");
    imageToFile().then((image) {
      fileToBase64(image).then((imageBase64)  {
        print("postData - ${image.uri}");
        if (isInteger(lastestId)) {
          final lastestIdInt = int.tryParse(lastestId);
          print("Lastest ID before POST: $lastestIdInt");
          int id = lastestIdInt! + 1;
          apiService.postData(MyData(id: id.toString(), userId: "1", title: "this is test title $id", body: "this is test bodyyyyyyyyyy $id", file: imageBase64));
        } else {
          debugPrint("Lastest ID is NOT Integer!");
        }
      });
    });
  }

  Widget buildRequestListView(List<Color> colors) {
    return FutureBuilder(
      future: apiService.getData(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null){

          var listData = snapshot.data!;

          print("Data Length: ${listData.length}");

          for (var jsonData in listData) {
            print("${jsonData.id}-${jsonData.file}");
            // if (jsonData.file != null) {
              // for (var file in jsonData.file!) {
              //   print(file);
              // }
            // }
          }

          if (listData.isNotEmpty) {
            postData(listData.last.id);
          } else {
            postData("0");
          }

          return ListView.separated(
            itemCount: listData.length,
            padding: const EdgeInsets.all(10),
            separatorBuilder: (context, index) => const SizedBox(height: 10,),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 1.5,
                        offset: const Offset(0, 0.5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row( 
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: 6,
                          decoration: BoxDecoration(
                            // color: getColor(listData[index].status),
                            color: Colors.red,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Giấy chứng nhận",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6,),
                              Text(
                                "Yeu cau: Loại GCN: Chứng nhận Sinh viên /HV/NCS\n"
                                "Số bản tiếng Việt: $index\n"
                                "Lý do: em xin giấy chứng nhận sinh viên và giấy hoãn nghĩa vụ quân sự để tạm hoãn lệnh gọi nghĩa vụ quân sự tại địa phương ạ.",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                              const SizedBox(height: 8,),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            "30-09-2023 02:11:46",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ),
                                      ],
                                    )
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          Icons.money,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            "${index}00.000000000000000000000",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        )
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context, 
                    builder: (context) => requestInforDialog(context, index, colors),
                  );
                },
              );
            }
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Container buildFilterButton(String? selectedStatus) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 35,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: const Icon(Icons.arrow_drop_down),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              iconSize: 14,
              elevation: 0,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12
              ),
              isExpanded: true,
              
              value: selectedStatus,
              items: ConstantList.requestStatus
                .map((status) => DropdownMenuItem<String>(
                  value: status,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(status),
                  )
                )).toList(), 
              onChanged: (status) => setState(() { 
                // setSelectedStatus(status);
                selectedStatus = status;
              }),
            ),
          );
        },
      ),
    );
  }

}