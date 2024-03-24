import 'package:datn/function/function.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    'assets/images/uet_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 15,),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Department of Information Systems",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF237625),
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const Text(
                        "University of Engineering and Technology",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF237625),
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        "311-E3, 144 Xuan Thuy, Cau Giay, Ha Noi, Vietnam",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF237625),
                          fontSize: 15,
                        ),
                      ),
                      InkWell(
                        child: const Text(
                          "http://uet.vnu.edu.vn/httt/",
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xFF002BD9),
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14
                          ),
                        ),
                        onTap: () {
                          openUrl(
                            context, 
                            urlString: "http://uet.vnu.edu.vn/httt/"
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8,),
          const Text(
            "HƯỚNG DẪN SỬ DỤNG",
            style: TextStyle(
              color: Color(0xFF000BD8),
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
          const Text(
            "Tài liệu dành cho sinh viên",
            style: TextStyle(
              fontSize: 18
            ),
          ),
          ExpansionTile(
            shape: const Border(),
            tilePadding: EdgeInsetsDirectional.zero,
            initiallyExpanded: true,
            title: Text(
              "Đăng nhập hệ thống",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            )
          ),
          ExpansionTile(
            shape: const Border(),
            tilePadding: EdgeInsetsDirectional.zero,
            initiallyExpanded: true,
            title: Text(
              "Giao diện và các chức năng chính",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            )
          ),
          ExpansionTile(
            shape: const Border(),
            tilePadding: EdgeInsetsDirectional.zero,
            initiallyExpanded: true,
            title: Text(
              "Tạo yêu cầu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            )
          ),
          ExpansionTile(
            shape: const Border(),
            tilePadding: EdgeInsetsDirectional.zero,
            initiallyExpanded: true,
            title: Text(
              "Xử lý yêu cầu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            )
          )
          ],
        ),
      ),
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
}