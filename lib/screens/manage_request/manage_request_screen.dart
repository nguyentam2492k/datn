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
    List myColors = [Colors.red, Colors.green, Colors.grey];
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
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      itemBuilder: (BuildContext context, int index) { 
        return GestureDetector(
          child: Container(
            // margin: EdgeInsets.all(5),
            padding: EdgeInsets.only(left: 7),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: colors[index],
                  width: 5
                )
              )
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Loai yeu cau: Giấy chứng nhận", 
                          textAlign: TextAlign.left, 
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Tinh trang: Da xong", 
                          textAlign: TextAlign.left, 
                          maxLines: 2,
                        ),
                        Text(
                          "Le phi: ${index}0.000", 
                          textAlign: TextAlign.left, 
                          maxLines: 1,
                        ),
                        Text(
                          "${index+1}-09-2023 02:11:46", 
                          textAlign: TextAlign.left, 
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Yeu cau: Loại GCN: Chứng nhận Sinh viên /HV/NCS\n"
                      "Số bản tiếng Việt: $index\n"
                      "Lý do: em xin giấy chứng nhận sinh viên và giấy hoãn nghĩa vụ quân sự để tạm hoãn lệnh gọi nghĩa vụ quân sự tại địa phương ạ.", 
                      textAlign: TextAlign.left, 
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  )
                ],
              ),
            ),
          ),
          onTap: (){
            showDialog(
              context: context, 
              builder: (context) => buildRequestInfoDialog(context, index)
            );
          },
        );
      },
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
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          padding: EdgeInsets.symmetric(horizontal: 8),
          iconSize: 13,
          elevation: 0,
          // focusColor: Colors.transparent,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12
          ),
          // isDense: true,
          isExpanded: true,
          
          value: selectedStatus,
          icon: Icon(Icons.filter_alt_outlined),
          items: requestStatus
            .map((status) => DropdownMenuItem<String>(
              value: status,
              child: Text(status)
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
                  child: Text(
                    "Ma",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    ), 
                  flex: 1,
                  ),
                Expanded(
                  child: Text("2710$index"), 
                  flex: 3,
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Sinh vien",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ), 
                  flex: 1,
                  ),
                Expanded(
                  child: Text(
                    "Nguyen Van Van Van Van Van Van Van Van Van Van Van Van Van Van Van Van Van Van Van $index"), 
                  flex: 3,
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Loai yeu cau",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ), 
                  flex: 1,
                  ),
                Expanded(
                  child: Text("Giay chung nhan"), 
                  flex: 3,
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Yeu cau",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ), 
                  flex: 1,
                  ),
                Expanded(
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
                  flex: 3,
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Tep dinh kem",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ), 
                  flex: 1,
                  ),
                Expanded(
                  child: Text("----------------"), 
                  flex: 3,
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Giay to can nop",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ), 
                  flex: 1,
                  ),
                Expanded(
                  child: Text("Khong"), 
                  flex: 3,
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Tinh trang",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),  
                  ), 
                  flex: 1,
                  ),
                Expanded(
                  child: Text("Da xong"), 
                  flex: 3,
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Le phi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),  
                  ), 
                  flex: 1,
                  ),
                Expanded(
                  child: Text("10.000"), 
                  flex: 3,
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Noi xu ly",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ), 
                  flex: 1,
                  ),
                Expanded(
                  child: Text("Phòng Công tác Sinh viên"), 
                  flex: 3,
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Ngay tao",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ), 
                  flex: 1,
                  ),
                Expanded(
                  child: Text("30-09-2023 02:11:46"), 
                  flex: 3,
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Ngay nhan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ), 
                  flex: 1,
                  ),
                Expanded(
                  child: Text("-------"), 
                  flex: 3,
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