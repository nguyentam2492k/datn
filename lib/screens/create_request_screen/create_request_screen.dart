import 'package:datn/widgets/create_request/request_1.dart';
import 'package:datn/widgets/create_request/request_2.dart';
import 'package:datn/widgets/create_request/request_3.dart';
import 'package:flutter/material.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return CreateRequestScreenState();
  }

}

class CreateRequestScreenState extends State<CreateRequestScreen> {
  List<String> requests = [
    "Giấy chứng nhận", 
    "Cấp bảng điểm", 
    "Đề nghị Hoãn thi", 
    "Xem lại bài thi", 
    "Hoãn nộp học phí", 
    "Mượn hồ sơ", 
    "XN trợ cấp xã hội", 
    "XN vay vốn ngân hàng", 
    "Cấp lại thẻ sinh viên", 
    "CN tốt nghiệp tạm thời", 
    "Nghỉ học có thời hạn", 
    "Tiếp tục học", 
    "Xin thôi học", 
    "Xác nhận đi nước ngoài", 
    "Chứng nhận còn nợ môn", 
    "XN nhận miễn giảm HP", 
    "Đề nghị làm vé xe buýt",
    "Cập nhật hồ sơ",
    "Đề nghị thuê nhà ở",
    "XN điểm rèn luyện",
    "Đánh giá Rèn luyện"
    ];
  List<Widget> requestWidgets = [
    request1(),
    request2(),
    request3(),
    request1(),
    request2(),
    request3(),
    request1(),
    request2(),
    request3(),
    request1(),
    request2(),
    request3(),
    request1(),
    request2(),
    request3(),
    request1(),
    request2(),
    request3(),
    request1(),
    request2(),
    request3(),
  ];
  late List<bool> isChecked;
  late String? selectedItem;

  @override
  void initState() {
    super.initState();
    isChecked = List.filled(requests.length, false);
    selectedItem = null;
  }

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
      title: const Text("Tạo yêu cầu"),
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
          child: Row(
            children: [
              const SizedBox(
                width: 80, 
                child: Text(
                  "Yêu cầu:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  
                  icon: const Icon(Icons.arrow_drop_down),
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
        SizedBox(
          height: 40,
          child: Text(
            selectedItem ?? "Welcome",
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Builder(builder: (BuildContext context) {
            if (selectedItem != null) {
              int index = requests.indexOf(selectedItem!);
              return requestWidgets[index];
            } else {
              return Container(
                color: Colors.cyan,
                child: const Text("Welcome Widget")
              );
            }
          },),
        ),
      ],
    );
  }

  Future<dynamic> openBottomSheet(String? slectedItem) {
    String? selectedItemChanged = selectedItem;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ListView.separated(
                      itemCount: requests.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          textColor: selectedItemChanged == requests[index] ? Colors.blue : Colors.black,
                          iconColor: selectedItemChanged == requests[index] ? Colors.blue : Colors.black,
                          title: Text(
                            requests[index],
                            textScaler: selectedItemChanged == requests[index] ? const TextScaler.linear(1.1) : const TextScaler.linear(1),
                            style: TextStyle(
                              fontWeight: selectedItemChanged == requests[index] ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: (){
                            selectedItemChanged = requests[index];
                            Navigator.pop(context, selectedItemChanged);
                          },
                        );
                      },
                    )
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.all(10),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: (){
                      Navigator.pop(context, selectedItemChanged);
                    },
                    child: const Text("Cancel"),
                  )
                ),
              ],
            );
          }
        );
      },
    );
  }
}