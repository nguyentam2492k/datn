import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request14 extends StatefulWidget {
  const Request14({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request14State();
  }
}

class Request14State extends State<Request14> {

  final GlobalKey<FormBuilderState> _request14FormKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> formData = {};

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request14FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
      return true;
    }
    return false;
  }

  void sendFormData() {
    formData.addAll(_request14FormKey.currentState!.value);
      
    // List<File> listFiles = files.map((file) => File(file.path!)).toList();
    List<String> listFiles = files.map((file) => file.name).toList();
    formData['file'] = listFiles;
    debugPrint(formData.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _request14FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    "Sinh viên làm đơn theo mẫu và kèm theo thư mời do tổ chức, "
                    "cá nhân trong, ngoài nước gửi, trong đó phải nêu rõ mục đích, "
                    "thời gian và các khoản tài chính (nếu do phía đối tác chi trả) "
                    "liên quan mà sinh viên đi nước ngoài được hưởng như vé máy bay, "
                    "tiền ăn, ở, sinh hoạt phí…scan và đính kèm vào yêu cầu. "
                    "Hồ sơ được giải quyết chậm nhất sau 05 ngày (không kể thứ Bảy, "
                    "Chủ nhật) kể từ ngày nhận hồ sơ. Sau 10 ngày kể từ ngày về nước "
                    "sinh viên phải hoàn thành việc nộp báo cáo theo mẫu cho Nhà trường. "
                    "Báo cáo nộp tại Văn phòng Khoa 01 bản và Phòng 104-E3 01 bản.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        InkWell(
                          child: const Text(
                            "Mẫu đơn",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                          ),
                          onTap: (){debugPrint("Tap Mau don");},
                        ),
                        InkWell(
                          child: const Text(
                            "Báo cáo",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                          ),
                          onTap: (){debugPrint("Tap Báo cáo");},
                        )
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.4,),
                  CustomTextFieldRowWidget(
                    labelText: "Lý do:",
                    name: 'reason',
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty ) {
                        return "Điền đầy đủ thông tin!";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 5,),
                  CustomUploadFileRowWidget(
                    files: files, 
                    isFileAdded: isFileAdded, 
                    onChanged: (List<PlatformFile> value) { 
                      files = value;
                      setState(() {});
                    }, 
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white
                ),
                onPressed: () {
                  isFileAdded = files.isEmpty ? false : true;
                  isFormValid() ? sendFormData() : null;
                  setState(() {});
                }, 
                label: const Text("Gửi yêu cầu"),
              ),
            ),
          )
        ],
      )
    );
  }
}