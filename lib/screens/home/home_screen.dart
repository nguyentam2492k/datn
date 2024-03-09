import 'package:datn/constants/constant_string.dart';
import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/login_model.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:datn/screens/create_request_screen/create_request_screen.dart';
import 'package:datn/screens/log_in/log_in.dart';
import 'package:datn/screens/manage_request/manage_request_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {

  final LoginResponseModel loginResponse;

  const HomeScreen({
    super.key, 
    required this.loginResponse,
  });

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late LoginResponseModel loginResponse;

  @override
  void initState() {
    super.initState();
    loginResponse = widget.loginResponse;
  }

  @override
  Widget build(BuildContext context) {
    globalLoginResponse = loginResponse;

    return LoaderOverlay(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        floatingActionButton: buidAddButton(context), 
        body: homeScreenBody(context),
        drawer: buildDrawer(context),
      ),
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
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(), 
      ),
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

  Widget homeScreenBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
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
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Đây là dịch vụ hỗ trợ gửi/nhận yêu cầu của Sinh viên đến các Phòng chức năng của trường Đại học Công nghệ - ĐHQG Hà Nội!\n\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000980),
                  )
                ),
                const TextSpan(
                  text: "Nếu cần hỗ trợ thêm, xin liên hệ với Bộ phận Tiếp người học - Phòng Công tác sinh viên.\n\n",
                  style: TextStyle(
                    color: Colors.black,
                  )
                ),
                const TextSpan(
                  text: "Liên kết nhanh:\n\n",
                  style: TextStyle(
                    color: Colors.black,
                  )
                ),
                const TextSpan(
                  text: "Website môn học: ",
                  style: TextStyle(
                    color: Color(0xFF2F38C2),
                  )
                ),
                TextSpan(
                  text: "${ConstantString.uetCourseUrl}\n\n",
                  style: const TextStyle(
                    color: Color(0xFF2F38C2),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    await openUrl(context, urlString: ConstantString.uetCourseUrl);
                  },
                ),
                const TextSpan(
                  text: "Hệ thống thư điện tử: ",
                  style: TextStyle(
                    color: Color(0xff2f38c2),
                  )
                ),
                TextSpan(
                  text: "${ConstantString.uetMailUrl}\n\n",
                  style: const TextStyle(
                    color: Color(0xFF2F38C2),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    await openUrl(context, urlString: ConstantString.uetMailUrl);
                  },
                ),
                const TextSpan(
                  text: "Trường Đại học Công nghệ: ",
                  style: TextStyle(
                    color: Color(0xff2f38c2),
                  )
                ),
                TextSpan(
                  text: ConstantString.uetWebsiteUrl,
                  style: const TextStyle(
                    color: Color(0xFF2F38C2),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    await openUrl(context, urlString: ConstantString.uetWebsiteUrl);
                  },
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
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide.none
      ),
      child: ListView( 
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(loginResponse.user.name), 
            accountEmail: Text(loginResponse.user.id),
            currentAccountPicture: Image.network(
              loginResponse.user.image,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeAlign: 2.5, 
                      color: Colors.white,
                    )
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.image_not_supported_outlined, size: 30, color: Colors.white70,)
                );
              },
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF000980),
            ),
          ),
          ListTile(
            title: const Text('Xử lý yêu cầu'),
            leading: const Icon(Icons.contact_page),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () async {
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
              print("Open Ho tro Page");
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
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) {
                    globalLoginResponse = null;
                    return const LogIn();
                  }), 
                  (route) => false
                );
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

  Future<void> openUrl(BuildContext context, {required String urlString}) async {
    var uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)){
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault
        );
    } else {
      if (context.mounted) {
        CustomSnackBar().showSnackBar(
          context,
          isError: true,
          errorText: "LỖI",
        );
      }
    }
  }
  
}
