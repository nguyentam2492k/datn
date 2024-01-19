import 'package:flutter/material.dart';
// import 'dart:math';

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
        appBar: buildAppBar(),
        body: manageRequestScreenBody(),
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

  Widget manageRequestScreenBody() {
    return ListView.separated(
      itemCount: 20,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      padding: EdgeInsets.all(5),
      itemBuilder: (BuildContext context, int index) { 
        return GestureDetector(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                color: Colors.red,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30, 
                      child: Text(
                        "Ma: $index", 
                        textAlign: TextAlign.left, 
                        style: TextStyle(
                          backgroundColor: Colors.cyan
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30, 
                      child: Text(
                        "Sinh vien: Nguyen Van $index", 
                        textAlign: TextAlign.left, 
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          backgroundColor: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30, 
                      child: Text(
                        "Loai yeu cau: $index$index$index$index$index", 
                        textAlign: TextAlign.left, 
                        style: TextStyle(
                          backgroundColor: Colors.cyan
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.yellow,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                              "Yeu cau: Loại GCN: Chứng nhận Sinh viên /HV/NCS\n"
                              "Số bản tiếng Việt: $index\n"
                              "Lý do: em xin giấy chứng nhận sinh viên và giấy hoãn nghĩa vụ quân sự để tạm hoãn lệnh gọi nghĩa vụ quân sự tại địa phương ạ.", 
                              textAlign: TextAlign.left, 
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(backgroundColor: Colors.cyan),),
                      SizedBox(
                        height: 30,
                        child: Text(
                          "Tinh trang: Da xong", 
                          textAlign: TextAlign.center, 
                          style: TextStyle(backgroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
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

  AlertDialog buildRequestInfoDialog(BuildContext context, int index) {
    debugPrint("Tap row $index");
    return AlertDialog(
      title: Text(
        "Thong tin yeu cau",
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