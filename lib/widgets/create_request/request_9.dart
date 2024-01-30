import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request9 extends StatefulWidget {
  const Request9({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request9State();
  }
}

class Request9State extends State<Request9> {

  final GlobalKey<FormBuilderState> _request9FormKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> formData = {};

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request9FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
      return true;
    }
    return false;
  }

  void sendFormData() {
    formData.addAll(_request9FormKey.currentState!.value);
      
    // List<File> listFiles = files.map((file) => File(file.path!)).toList();
    List<String> listFiles = files.map((file) => file.name).toList();
    formData['file'] = listFiles;
    debugPrint(formData.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _request9FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    "Chú ý: Sinh viên (nhập học từ, sau 2018) "
                    "làm thẻ tích hợp cần vào mục Cập nhật hồ sơ "
                    "để cập nhật Ảnh thẻ và thông tin về CMTND trước khi thực hiện mục này ;"
                    "-Sinh viên điền đầy đủ thông tin về Ngành học, "
                    "Khoa, Lớp trong phần Lý do, đính kèm 01 ảnh 3x4 "
                    "(tên file ảnh ghi Họ tên - không dấu); đến Phòng "
                    "104-E3 để nộp lệ phí sau 03 ngày đăng ký Online; "
                    "Khi làm xong, Phòng CTSV sẽ báo cho sinh viên đến nhận",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
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