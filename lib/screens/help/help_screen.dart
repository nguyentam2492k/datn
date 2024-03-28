import 'package:datn/function/function.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 88,
                  width: 88,
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
                          fontSize: 15.5,
                        ),
                      ),
                      const Text(
                        "311-E3, 144 Xuan Thuy, Cau Giay, Ha Noi, Vietnam",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF237625),
                          fontSize: 14.5,
                        ),
                      ),
                      InkWell(
                        child: const Text(
                          "http://uet.vnu.edu.vn/httt/",
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xFF002BD9),
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13.5,
                            decoration: TextDecoration.underline
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
          const SizedBox(height: 20,),
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
              fontSize: 16
            ),
          ),
          const Divider(thickness: 0.4,),
          ExpansionTile(
            shape: const Border(),
            tilePadding: EdgeInsetsDirectional.zero,
            initiallyExpanded: false,
            childrenPadding: EdgeInsets.zero,
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: const Text(
              "Đăng nhập hệ thống",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.5
              ),
            ),
            children: [
              const Text("Để vào website hệ thống, Sinh viên vào trực tiếp tại địa chỉ sau:"),
              InkWell(
                child: const Text(
                  'http://student.uet.vnu.edu.vn', 
                  style: TextStyle(
                    color: Color(0xFF1100FF),
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => openUrl(context, urlString: 'http://student.uet.vnu.edu.vn')
              ),
              const SizedBox(height: 10,),
              const Text("Giao diện đăng nhập của hệ thống như hình dưới đây:"),
              const SizedBox(height: 10,),
              Image(
                image: const AssetImage('assets/help_page_images/1_login.png'),
                fit: BoxFit.contain,
                height: screenSize.height * 2/3,
                alignment: Alignment.center,
              ),
              const Text("Sinh viên đăng nhập vào hệ thống bằng cách nhập \"Tên đăng nhập\" và \"Mật khẩu\" vào khung đăng nhập của hệ thống, sau đó nhấn nút \"Đăng nhập\"."),
              const SizedBox(height: 10,),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.35
                  ),
                  children: [
                    TextSpan(
                      text: "Lưu ý 1: ",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    TextSpan(
                      text: "\"Tên đăng nhập\" và \"Mật khẩu\" của sinh viên chính là email sinh viên (tên đăng nhập) và mật khẩu là mật khẩu đăng nhập email được nhà trường cấp khi nhập trường.\n"
                    ),
                    TextSpan(
                      text: "Lưu ý 2: ",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    TextSpan(
                      text: "Sinh viên nên tích vào ô \"Ghi nhớ tài khoản\" để ghi nhớ thông tin tài khoản trong lần sử dụng sau."
                    )
                  ]
                )
              ),
              const SizedBox(height: 10,),
              const Text("Ví dụ: Sinh viên có tài khoản đăng nhập email là: \"21021234@vnu.edu.vn\", password \"A12345678\", thì đăng nhập vào hệ thống với:"),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.35
                    ),
                    children: [
                      TextSpan(
                        text: "Tên đăng nhập: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic
                        )
                      ),
                      TextSpan(
                        text: "21021234@vnu.edu.vn\n"
                      ),
                      TextSpan(
                        text: "Mật khẩu: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic
                        )
                      ),
                      TextSpan(
                        text: "A12345678"
                      ),
                    ]
                  )
                ),
              ),
            ],
          ),
          const Divider(thickness: 0.4,),
          ExpansionTile(
            shape: const Border(),
            tilePadding: EdgeInsetsDirectional.zero,
            initiallyExpanded: false,
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: const Text(
              "Giao diện và các chức năng chính",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.5
              ),
            ),
            children: [
              const Text("Sau khi đăng nhập, giao diện màn hình chính(Home) sẽ như hình dưới đây:"),
              const SizedBox(height: 10,),
              Image(
                image: const AssetImage('assets/help_page_images/2_home.png'),
                fit: BoxFit.contain,
                height: screenSize.height * 2/3,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 10,),
              const Text("Màn Home có 2 nút nhấn chính là: "),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black
                  ),
                  children: [
                    TextSpan(text: "• Nút Menu "),
                    WidgetSpan(child: Image(
                      image: AssetImage('assets/help_page_images/menu_button.png'),
                      fit: BoxFit.contain,
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                    )),
                    TextSpan(text: " ở góc trên bên trái dùng để mở Menu"),
                  ],
                ),
              ),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black
                  ),
                  children: [
                    TextSpan(text: "• Nút \"Tạo yêu cầu\" "),
                    WidgetSpan(child: Image(
                      image: AssetImage('assets/help_page_images/create_request_button.png'),
                      fit: BoxFit.contain,
                      height: 30,
                      // width: 20,
                      alignment: Alignment.center,
                    )),
                    TextSpan(text: "ở góc dưới bên phải để mở trang Tạo yêu cầu một cách nhanh chóng"),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Sau khi nhấn vào nút Menu, một menu như hình dưới sẽ xuất hiện"),
              const SizedBox(height: 10,),
              Image(
                image: const AssetImage('assets/help_page_images/3_menu.png'),
                fit: BoxFit.contain,
                height: screenSize.height * 2/3,
                alignment: Alignment.center,
              ),
              const Text("Menu trên có các nút sau:"),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.35
                    ),
                    children: [
                      TextSpan(
                        text: "• Xử lý yêu cầu: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Mở trang \"Xử lý yêu cầu\"\n"
                      ),
                      TextSpan(
                        text: "• Tạo yêu cầu: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Mở trang \"Tạo yêu cầu\"\n"
                      ),
                      TextSpan(
                        text: "• Hỗ trợ: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Mở trang \"Hỗ trợ\"\n"
                      ),
                      TextSpan(
                        text: "• Đăng xuất: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Đăng xuất khỏi tài khoản đang sử dụng"
                      ),
                    ]
                  )
                ),
              ),
            ],
          ),
          const Divider(thickness: 0.4,),
          ExpansionTile(
            shape: const Border(),
            tilePadding: EdgeInsetsDirectional.zero,
            initiallyExpanded: false,
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: const Text(
              "Tạo yêu cầu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.5
              ),
            ),
            children: [
              const Text("Muốn tạo yêu cầu mới, sinh viên làm theo các bước sau đây (Từ màn hình chính):"),
              const SizedBox(height: 10,),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.35
                  ),
                  children: [
                    TextSpan(
                      text: "• Bước 1: ",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    TextSpan(
                      text: "Vào \"Menu/Tạo yêu cầu\" hoặc có thể nhấn vào nút \"Tạo yêu cầu\" ở ngay màn hình chính"
                    ),
                  ]
                )
              ),
              const SizedBox(height: 10,),
              const Text("Giao diện màn Tạo yêu cầu sẽ như hình dưới đây:"),
              const SizedBox(height: 10,),
              Image(
                image: const AssetImage('assets/help_page_images/4_create_request.png'),
                fit: BoxFit.contain,
                height: screenSize.height * 2/3,
                alignment: Alignment.center,
              ),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.35
                  ),
                  children: [
                    TextSpan(
                      text: "• Bước 2: ",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    TextSpan(
                      text: "Nhấn vào nút \"Chọn yêu cầu\" ở phía trên, sau khi nhấn vào nút, một bảng chọn như hình dưới sẽ xuất hiện, sau đó nhấn chọn một yêu cầu mong muốn"
                    ),
                  ]
                )
              ),
              const SizedBox(height: 10,),
              Image(
                image: const AssetImage('assets/help_page_images/5_list_request.png'),
                fit: BoxFit.contain,
                height: screenSize.height * 2/3,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 10,),
              const Text("Sau khi chọn một yêu cầu, màn tạo yêu cầu đó sẽ mở ra. Giao diện tạo yêu cầu chi tiết như hình dưới:"),
              const SizedBox(height: 10,),
              Image(
                image: const AssetImage('assets/help_page_images/6_request.png'),
                fit: BoxFit.contain,
                height: screenSize.height * 2/3,
                alignment: Alignment.center,
              ),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.35
                  ),
                  children: [
                    TextSpan(
                      text: "• Bước 3: ",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    TextSpan(
                      text: "Cung cấp/Điền đầy đủ các thông tin cần thiết để có thể tạo yêu cầu"
                    ),
                  ]
                )
              ),
              const SizedBox(height: 10,),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.35
                  ),
                  children: [
                    TextSpan(
                      text: "• Bước 4: ",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    TextSpan(
                      text: "Bấm nút \"Gửi yêu cầu\" để gửi yêu cầu của mình đến nhà trường."
                    ),
                  ]
                )
              ),
              const SizedBox(height: 10,),
              const Text("Sau khi bấm \"Lưu\", yêu cầu đã được gửi thành công. Sinh viên có thể kiểm tra trạng thái yêu cầu của mình gửi ở màn \"Xử lý yêu cầu\".")
            ],
          ),
          const Divider(thickness: 0.4,),
          ExpansionTile(
            shape: const Border(),
            tilePadding: EdgeInsetsDirectional.zero,
            initiallyExpanded: false,
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: const Text(
              "Xử lý yêu cầu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.5
              ),
            ),
            children: [
              const Text("Chức năng \"Xử lý yêu cầu\" trong \"Menu/Xử lý yêu cầu\" hỗ trợ sinh viên theo dõi trạng thái chi tiết của yêu cầu. Giao diện \"Xử lý yêu cầu\" như hình dưới đây:"),
              const SizedBox(height: 10,),
              Image(
                image: const AssetImage('assets/help_page_images/7_manage_request.png'),
                fit: BoxFit.contain,
                height: screenSize.height * 2/3,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 10,),
              const Text("Trong màn này chỉ chứa các thông tin cơ bản của một yêu cầu như: \"Mã yêu cầu\", \"Loại yêu cầu\", \"Nội dung của yêu cầu\", \"Ngày tạo\" và \"Lệ phí\""),
              const SizedBox(height: 10,),
              const Text("Để xem chi tiết toàn bộ thông tin của một yêu cầu, phải nhấn vào yêu cầu muốn xem. Sau khi nhấn, một màn hình như dưới sẽ hiện lên:"),
              const SizedBox(height: 10,),
              Image(
                image: const AssetImage('assets/help_page_images/8_request_details.png'),
                fit: BoxFit.contain,
                height: screenSize.height * 2/3,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 10,),
              const Text("Các thông tin chính trong cửa sổ trên:"),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.35
                    ),
                    children: [
                      TextSpan(
                        text: "• Mã: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Mã số yêu cầu được tạo tự động.\n"
                      ),
                      TextSpan(
                        text: "• Sinh viên: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Tên sinh viên tạo yêu cầu.\n"
                      ),
                      TextSpan(
                        text: "• Loại yêu cầu: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Loại yêu cầu được tạo theo danh sách yêu cầu.\n"
                      ),
                      TextSpan(
                        text: "• Yêu cầu: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Chi tiết nội dung yêu cầu.\n"
                      ),
                      TextSpan(
                        text: "• Giấy tờ cần nộp: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "3 trạng thái\n"
                      ),
                      WidgetSpan(child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("- Không: Sinh viên không cần nộp thêm giấy tờ nào."),
                            Text("- Chưa nhận: Giấy tờ cần thiết đi kèm yêu cầu Sinh viên chưa nộp."),
                            Text("- Đã nhận: Giấy tờ cần thiết đi kèm yêu cầu khi Sinh viên đã nộp đầy đủ.")
                          ],
                        ),
                      )),
                      TextSpan(
                        text: "• Tình trạng: \n",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      WidgetSpan(child: Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("- Đã tiếp nhận: Sinh viên đã gửi yêu cầu thành công, đợi chuyên viên xử lý."),
                            Text("- Đã phân công: Yêu cầu đã được phân công đến từng phòng ban thích hợp để xử lý."),
                            Text("- Đang thực hiện: Yêu cầu đang được xử lý tại các phòng ban."),
                            Text("- Đã xong: Yêu cầu đã được thực hiện xong. Khi yêu cầu chuyển sang trạng thái này Sinh viên có thể đến Phòng Công tác sinh viên nhận các giấy tờ có đóng dấu, xác nhận. (Nếu có)."),
                            Text("- Đã nhận: Dành cho các yêu cầu có trả các giấy tờ cần đóng dấu, xác nhận. "),
                            Text("- Hủy: Yêu cầu của Sinh viên không điền đầy đủ, chi tiết các thông tin cần thiết, hoặc yêu cầu đó của Sinh viên không được chấp nhận.")
                          ],
                        ),
                      )),
                      TextSpan(
                        text: "• Lệ phí: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Lệ phí đối với yêu cầu.\n"
                      ),
                      TextSpan(
                        text: "• Nơi xử lý: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Phòng, ban xử lý các yêu cầu của Sinh viên.\n"
                      ),
                      TextSpan(
                        text: "• Hạn hoàn thành: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Hạn cuối cùng để hoành thành yêu cầu.\n"
                      ),
                      TextSpan(
                        text: "• Ngày tạo: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Đây là thời gian tạo yêu cầu của Sinh viên.\n"
                      ),
                      TextSpan(
                        text: "• Ngày nhận: ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      TextSpan(
                        text: "Đây là thời gian nhận yêu cầu của Sinh viên.\n"
                      ),
                    ]
                  )
                ),
              ),
            ],
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