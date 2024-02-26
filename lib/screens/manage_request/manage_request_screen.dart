import 'dart:convert';
import 'dart:io';

import 'package:datn/api/api_service.dart';
import 'package:datn/constants/constant_list.dart';
import 'package:datn/model/login_model.dart';
import 'package:datn/model/request/request_information_model.dart';
import 'package:datn/widgets/manage_request/request_information_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ManageRequestScreen extends StatefulWidget {

  final LoginResponseModel loginResponseData;

  const ManageRequestScreen({
    super.key,
    required this.loginResponseData,
  });
  
  @override
  State<StatefulWidget> createState() {
    return ManageRequestScreenState();
  }
}

class ManageRequestScreenState extends State<ManageRequestScreen> {

  static const double loadingIndicatorSize = 20;

  APIService apiService = APIService();
  ValueNotifier<List<RequestInformation>> listRequest = ValueNotifier([]);
  
  String? currentStatus = ConstantList.requestStatus[0];
  int currentIndex = 0;
  late String accessToken;

  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    accessToken = widget.loginResponseData.accessToken;
    scrollController.addListener(() {
      _handleScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    // apiService.getData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: manageRequestScreenBody(ConstantList.requestStatus, currentStatus),
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

    return Stack(
      children: [
        buildRequestListView(),

        Align(
          alignment: Alignment.topRight,
          child: buildFilterButton(currentStatus),
        ),
      ]
    );
  }

  Color getColor(String status) {
    switch (status) {
      case "completed":
        return Colors.green;
      case "canceled":
        return Colors.red;
      case "processing":
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  String formatTime(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd hh:mm');
    var inputDate = inputFormat.parse(date);
    
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
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

  Future<void> _loadMore() async {
    print("LOAD MORE");
    isLoading = true;
    currentIndex += 10;
    await apiService.getData(currentStatus, currentIndex, accessToken).then((value) async {
      await Future.delayed(const Duration(seconds: 1));
      print("ADD-${value.length}");
      listRequest.value.addAll(value);
      listRequest.value = List.from(listRequest.value);
      if (value.length == 10) {
        isLoading = false;
      }
      print(listRequest.value.length);
    });
  }

  void _handleScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - loadingIndicatorSize && !isLoading && listRequest.value.length % 10 == 0) {
        _loadMore();
    }
  }

  Widget buildRequestListView() {
    return FutureBuilder(
      future: apiService.getData(currentStatus, currentIndex, accessToken), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done){
          if (snapshot.data!.length < 10) {
            isLoading = true;
          }

          // var listData = snapshot.data!;

          // listRequest.value.addAll(snapshot.data!);
          listRequest.value.addAll(snapshot.data!);
          listRequest.value = List.from(listRequest.value);
          print("Data Length: ${listRequest.value.length}");

          // for (var jsonData in listData) {
            // print("${jsonData.id}-${jsonData.info.runtimeType}");
            // if (jsonData.file != null) {
              // for (var file in jsonData.file!) {
              //   print(file);
              // }
            // }
          // }

          // if (listData.isNotEmpty) {
          //   postData(listData.last.id);
          // } else {
          //   postData("0");
          // }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Chưa có yêu cầu nào!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7B7B7B),
                  fontSize: 12
                ),
              ),
            );
          }

          return NotificationListener(
            // onNotification: _handleScrollNotification,
            child: ValueListenableBuilder(
              valueListenable: listRequest,
              builder: (context, list, child) {
                print("BUILD");
                return ListView.separated(
                  controller: scrollController,
                  itemCount: list.length + 1,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                  separatorBuilder: (context, index) => const SizedBox(height: 10,),
                  itemBuilder: (BuildContext context, int index) {
                    
                    if (index == list.length) {
                      return !isLoading
                        ? Visibility(
                          visible: !isLoading,
                          child: const Center(
                            child: SizedBox(
                              height: loadingIndicatorSize,
                              width: loadingIndicatorSize,
                              child: CircularProgressIndicator(color: Color(0xFF1E3CFF), strokeWidth: 2.25,)
                            ),
                          )
                        )
                        : const Text(
                            "Đã tải toàn bộ yêu cầu!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10
                            ),
                          );
                    }
                    return GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 8, 20, 10),
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
                                width: 7,
                                decoration: BoxDecoration(
                                  color: getColor(list[index].status),
                                  // color: Colors.red,
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                                ),
                              ),
                              const SizedBox(width: 15,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[index].requestType,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      "Yeu cau: Loại GCN: Chứng nhận Sinh viên /HV/NCS\n"
                                      "Số bản tiếng Việt: $index\n"
                                      "Lý do: em xin giấy chứng nhận sinh viên và giấy hoãn nghĩa vụ quân sự để tạm hoãn lệnh gọi nghĩa vụ quân sự tại địa phương ạ. em xin giấy chứng nhận sinh viên và giấy hoãn nghĩa vụ quân sự để tạm hoãn lệnh gọi nghĩa vụ quân sự tại địa phương ạ. em xin giấy chứng nhận sinh viên và giấy hoãn nghĩa vụ quân sự để tạm hoãn lệnh gọi nghĩa vụ quân sự tại địa phương ạ.",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 6,
                                    ),
                                    const SizedBox(height: 7,),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 5,),
                                              Flexible(
                                                child: Text(
                                                  formatTime(list[index].dateCreate),
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
                                                Icons.attach_money_rounded,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 5,),
                                              Flexible(
                                                child: Text(
                                                  list[index].fee ?? "----",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 5,),
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
                          builder: (context) => requestInforDialog(context, index, getColor(list[index].status)),
                        );
                      },
                    );
                  }
                );
              },
            ),
          );
        } else {
          return const Center(
            child: SizedBox(
              height: loadingIndicatorSize + 5,
              width: loadingIndicatorSize + 5,
              child: CircularProgressIndicator(color: Color(0xFF1E3CFF), strokeWidth: 2.75,)
            ),
          );
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
      child: DropdownButtonHideUnderline(
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
          onChanged: (status) {
            // setCurrentStatus(status);
            listRequest.value = [];
            currentIndex = 0;
            isLoading = false;
            currentStatus = status;
            setState(() {});
          },
        ),
      ),
    );
  }

}