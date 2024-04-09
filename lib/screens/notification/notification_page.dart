import 'package:datn/function/function.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return NotificationPageState();
  }
  
}

class NotificationPageState extends State<NotificationPage> {

  var listNotification = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("Thông báo"),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.3,
          )
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(10),
          separatorBuilder: (_, __) => const SizedBox(height: 10,), 
          itemCount: 20,
          itemBuilder: (context, index) {
            // if (listNotification.isEmpty) {
            //   return Center(child: Text("Không có thông báo nào."));
            // }
        
            return Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB0B0B0).withOpacity(0.3),
                    blurRadius: 1.5,
                    offset: const Offset(0, 0.35),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 28,
                                width: 28,
                                child: getStatusIcon(statusId: 2, size: 28)
                              ),
                              const SizedBox(width: 5,),
                              const Flexible(
                                child: Text.rich(
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    overflow: TextOverflow.ellipsis
                                  ),
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Yêu cầu "
                                      ),
                                      TextSpan(
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600
                                        ),
                                        text: "Mượn hồ sơ "
                                      ),
                                      TextSpan(
                                        text: "đã xongggggggggggggggggggggggggggggg"
                                      )
                                    ]
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      const Text(
                        "2 giờ trước",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF848484)
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Row(
                    children: [
                      SizedBox(width: 33,),
                      Expanded(
                        child: Text(
                          "Loại GCN: Chứng nhận Sinh viên /HV/NCS\n"
                          "Số bản tiếng Việt: 1\n"
                          "Lý do: em xin giấy chứng nhận sinh viên và giấy hoãn nghĩa vụ quân sự để tạm hoãn lệnh gọi nghĩa vụ quân sự tại địa phương ạ.",
                          style: TextStyle(
                            color: Color(0xFF474747),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }, 
        ),
      ),
    );
  }
  
}