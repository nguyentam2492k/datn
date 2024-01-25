import 'package:datn/widgets/create_request/request_1.dart';
import 'package:datn/widgets/create_request/request_2.dart';
import 'package:datn/widgets/create_request/request_3.dart';
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
  final List<Widget> requestWidgets = [
    const Request1(),
    const Request2(),
    const Request3(),
    const Request1(),
    const Request2(),
    const Request3(),
    const Request1(),
    const Request2(),
    const Request3(),
    const Request1(),
    const Request2(),
    const Request3(),
    const Request1(),
    const Request2(),
    const Request3(),
    const Request1(),
    const Request2(),
    const Request3(),
    const Request1(),
    const Request2(),
    const Request3(),
  ];
  late String? selectedItem;

  @override
  void initState() {
    super.initState();
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
        Container(
          height: 0.3,
          color: Colors.grey,
        ),
        const SizedBox(height: 10,),
        Expanded(
          child: Builder(builder: (BuildContext context) {
            if (selectedItem != null) {
              int index = requests.indexOf(selectedItem!);
              return requestWidgets[index];
            } else {
              return welcomeCreateRequest();
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
          list: requests,
          selectedItem: selectedItemChanged,
        );
      },
    );
  }
}