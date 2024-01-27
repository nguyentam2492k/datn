import 'package:flutter/material.dart';

Widget welcomeCreateRequest() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: const Text(
          "Dịch vụ gửi yêu cầu của trường Đại học Công nghệ!\nHãy chọn yêu cầu bằng nút bên trên",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 10,),
      RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
          children: [
            TextSpan(
              text: "Chú ý: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              )
            ),
            TextSpan(
              text: 
                "Các yêu cầu đã được hệ thống ghi nhận sẽ không thể chỉnh sửa. "
                "Sinh viên/Học viên/NCS cần kiểm tra thật kỹ những yêu cầu của mình trước ghi nhận "
                "và gửi đến phòng chức năng của Trường Đại học Công nghệ. "
                "Sinh viên/Học viên/NCS phải chịu trách nhiệm và tuân theo những quy định đã đề ra của Trường Đại học Công nghệ.",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black
                )
            )
          ]
        ),
      ),
    ],
  );
}