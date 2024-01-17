import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      floatingActionButton: buidAddButton(), 
      body: homeScreenBody(),
      drawer: buildDrawer(context),
    );
  }

  FloatingActionButton buidAddButton() {
    return FloatingActionButton.extended(
      onPressed: () => debugPrint('Tao yeu cau'),
      icon: const Icon(Icons.add),
      label: Text('Tạo yêu cầu'),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    );
  }

  Widget homeScreenBody() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.3,
          )
        )
      ),
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: "Đây là dịch vụ hỗ trợ gửi/nhận yêu cầu của Sinh viên đến các Phòng chức năng của trường Đại học Công nghệ - ĐHQG Hà Nội!\n\n",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF000980),
              )
            ),
            TextSpan(
              text: "Nếu cần hỗ trợ thêm, xin liên hệ với Bộ phận Tiếp người học - Phòng Công tác sinh viên.\n\n",
            ),
            TextSpan(
              text: "Liên kết nhanh:\n\n",
            ),
            TextSpan(
              text: "Website môn học: http://bbc.vnu.edu.vn\n\n",
              style: TextStyle(
                color: Color(0xFF2F38C2),
              )
            ),
            TextSpan(
              text: "Hệ thống thư điện tử: https://ctmail.vnu.edu.vn\n\n",
              style: TextStyle(
                color: Color(0xff2f38c2),
              )
            ),
            TextSpan(
              text: "Trường Đại học Công nghệ: http://uet.vnu.edu.vn",
              style: TextStyle(
                color: Color(0xff2f38c2),
              )
            ),
          ]
        )
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("18021116"), 
            accountEmail: Text("18021116@vnu.edu.vn"),
            decoration: BoxDecoration(
              color: Color(0xFF000980),
            ),
          ),
          ListTile(
            title: Text('Xử lý yêu cầu'),
            leading: const Icon(Icons.contact_page),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Tạo yêu cầu'),
            leading: const Icon(Icons.note_add_rounded),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Hỗ trợ'),
            leading: Icon(Icons.help),
            onTap: () {
              debugPrint("Open Ho tro Page");
            },
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.3,
        )
      ),
      title: Image(
        image: AssetImage('assets/icons/uet.png'),
        fit: BoxFit.contain,
        height: 40,
      ),
      // foregroundColor: Colors.black,
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(), 
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.settings)
          ),
        )
      ],
    );
  }

}