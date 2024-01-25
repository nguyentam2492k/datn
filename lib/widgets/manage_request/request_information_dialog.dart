import 'package:flutter/material.dart';

Widget requestInforDialog(BuildContext context, int index, List<Color> colors) {
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