import 'package:datn/screens/create_request_screen/create_request_screen.dart';
import 'package:datn/screens/manage_request/manage_request_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      floatingActionButton: buidAddButton(context), 
      body: homeScreenBody(),
      drawer: buildDrawer(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      shape: const Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.3,
        )
      ),
      title: const Image(
        image: AssetImage('assets/images/uet.png'),
        fit: BoxFit.contain,
        height: 40,
      ),
      // foregroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(), 
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.settings)
          ),
        )
      ],
    );
  }

  FloatingActionButton buidAddButton(BuildContext context) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add),
      label: const Text('Tạo yêu cầu'),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      onPressed: () {
        Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const CreateRequestScreen()
                )
              );
      },
    );
  }

  Widget homeScreenBody() {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.3,
          )
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Chào mừng",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red
            ),
          ),
          const SizedBox(height: 5,),
          RichText(
            text: const TextSpan(
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
                  style: TextStyle(
                    color: Colors.black,
                  )
                ),
                TextSpan(
                  text: "Liên kết nhanh:\n\n",
                  style: TextStyle(
                    color: Colors.black,
                  )
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
        ],
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView( 
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("18021116"), 
            accountEmail: Text("18021116@vnu.edu.vn"),
            currentAccountPicture: Image(
              image: AssetImage('assets/images/uet.png'),
              fit: BoxFit.contain,
            ),
            decoration: BoxDecoration(
              color: Color(0xFF000980),
            ),
          ),
          ListTile(
            title: const Text('Xử lý yêu cầu'),
            leading: const Icon(Icons.contact_page),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const ManageRequestScreen()
                )
              );
            },
          ),
          ListTile(
            title: const Text('Tạo yêu cầu'),
            leading: const Icon(Icons.note_add_rounded),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const CreateRequestScreen()
                )
              );
            },
          ),
          ListTile(
            title: const Text('Hỗ trợ'),
            leading: const Icon(Icons.help),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              debugPrint("Open Ho tro Page");
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 0.3,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
            child: ElevatedButton.icon(
              onPressed: (){
                debugPrint("Dang xuat");
              },
              icon: const Icon(Icons.logout),
              label: const Text("Đăng xuất"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0
              )
            ),
          )
        ],
      ),
    );
  }

}