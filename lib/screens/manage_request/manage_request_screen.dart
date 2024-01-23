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
  List<String> requestStatus = ["Tất cả", "Đang xử lý", "Đã xong", "Đã huỷ"];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = requestStatus[0];
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
      title: const Text("Xử lý yêu cầu"),
      centerTitle: true,
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

  ListView buildRequestListView(List<Color> colors) {
    return ListView.separated(
      itemCount: 20,
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
                      color: colors[index],
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
                        const SizedBox(height: 5,),
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
                                  Text("30-09-2023 02:11:46"),
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
              builder: (context) => buildRequestInfoDialog(context, index, colors)
            );
          },
        );
      }
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
            items: requestStatus
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

  AlertDialog buildRequestInfoDialog(BuildContext context, int index, List<Color> colors) {
    return AlertDialog(
      elevation: 0,
      titlePadding: const EdgeInsets.symmetric(),
      title: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
        
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              height: 16,
              decoration: BoxDecoration(
                color: colors[index],
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
              ),
            ),
            const SizedBox(height: 18,),
            const Text(
              "Chi tiết yêu cầu",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10,),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    "Mã",
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
            const Divider(),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    "Sinh viên",
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
            const Divider(),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Loại yêu cầu",
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
            const Divider(),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Yêu cầu",
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
            const Divider(),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Tệp đính kèm",
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
            const Divider(),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Giấy tờ cần nộp",
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
            const Divider(),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Tình trạng",
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
            const Divider(),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Lệ phí",
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
            const Divider(),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Nơi xử lý",
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
            const Divider(),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Ngày tạo",
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
            const Divider(),
            const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Ngày nhận",
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
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

}