import 'package:flutter/material.dart';
import 'dart:math';

class ManageRequestScreen extends StatefulWidget {
  const ManageRequestScreen({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return ManageRequestScreenState();
  }
}

class ManageRequestScreenState extends State<ManageRequestScreen> {
  List<String> requestStatus = ["Tat ca", "Dang xu ly", "Da xong", "Da huy"];
  String? selectedStatus = "Tat ca";

  void setSelectedStatus(String? value) {
    selectedStatus = value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(),
        body: manageRequestScreenBody(requestStatus, selectedStatus),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Xử lý yêu cầu"),
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

  Widget manageRequestScreenBody(List<String> listStatus, String? selectedStatus) {

    //Random color for test
    List myColors = [Colors.red, Colors.green, Colors.orangeAccent];
    List colors = <Color>[];
    for(int i=0; i < 20; i++) {
      colors.add(myColors[Random().nextInt(3)]);
    }

    debugPrint(selectedStatus);
    
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

  ListView buildRequestListView(List<dynamic> colors) {
    return ListView.separated(
      itemCount: 20,
      padding: EdgeInsets.all(10),
      separatorBuilder: (context, index) => SizedBox(height: 10,),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 8, 20, 8),
             decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 1.5,
                  offset: Offset(0, 0.5), // changes position of shadow
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row( 
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 6,
                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Giấy chứng nhận",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Yeu cau: Loại GCN: Chứng nhận Sinh viên /HV/NCS\n"
                          "Số bản tiếng Việt: $index\n"
                          "Lý do: em xin giấy chứng nhận sinh viên và giấy hoãn nghĩa vụ quân sự để tạm hoãn lệnh gọi nghĩa vụ quân sự tại địa phương ạ.",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("30-09-2023 02:11:46"),
                                ],
                              )
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.money,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("${index}00.000")
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
              builder: (context) => buildRequestInfoDialog(context, index)
            );
          },
        );
      }
    );
  }

  Container buildFilterButton(String? selectedStatus) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 35,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          icon: Icon(Icons.arrow_drop_down),
          padding: EdgeInsets.symmetric(horizontal: 8),
          iconSize: 14,
          elevation: 0,
          // focusColor: Colors.transparent,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12
          ),
          isExpanded: true,
          
          value: selectedStatus,
          items: requestStatus
            .map((status) => DropdownMenuItem<String>(
              value: status,
              child: Align(
                child: Text(status),
                alignment: Alignment.center,
              )
            )).toList(), 
          onChanged: (status) => setState(() { 
            setSelectedStatus(status);
            debugPrint("Change button to $status");
            debugPrint(selectedStatus);
          }),
        ),
      ),
    );
  }

  AlertDialog buildRequestInfoDialog(BuildContext context, int index) {
    debugPrint("Tap row $index");
    return AlertDialog(
      elevation: 0,
      title: Text(
        "Chi tiet yeu cau",
        style: TextStyle(
          fontWeight: FontWeight.bold
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Ma",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text("2710$index"),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Sinh vien",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Nguyen Van Van Van Van Van Van Van Van Van Van Van Van Van Van Van Van Van Van Van $index"),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Loai yeu cau",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text("Giay chung nhan"),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Yeu cau",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Loại GCN: Hoãn nghĩa vụ quân sự\n"
                    "Số bản tiếng Việt: 1\n"
                    "Lý do: Do hiện tại địa phương em đang xét tuyển nghĩa vụ quân sự. "
                    "Trong khi đó, giấy hoãn nghĩa vụ quân sự của trường chỉ có thời hạn 4 năm, "
                    "mà em chuẩn bị bước sang năm học thứ 5 nhưng vẫn chưa hoàn thành xong chương trình học 4.5 năm của mình "
                    "và chưa tốt nghiệp, nên em mong muốn được nhận giấy hoãn nghĩa vụ quân sự từ phía trường "
                    "để em nộp cho địa phương để có thể hoàn thành nốt chương trình học còn dang dở và tốt nghiệp xong ạ. "
                    "Nếu được thì em có thể nhận bản mềm qua hòm thư được không ạ Em xin cảm ơn!"
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Tep dinh kem",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text("----------------"),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Giay to can nop",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text("Khong"),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Tinh trang",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),  
                  ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text("Da xong"),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Le phi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),  
                  ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text("10.000"),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Noi xu ly",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text("Phòng Công tác Sinh viên"),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Ngay tao",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text("30-09-2023 02:11:46"),
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Ngay nhan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  ),
                Expanded(
                  flex: 3,
                  child: Text("-------"),
                )
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

}