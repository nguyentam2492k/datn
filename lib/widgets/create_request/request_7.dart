import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request7 extends StatefulWidget {
  const Request7({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request7State();
  }
}

class Request7State extends State<Request7> {

  final GlobalKey<FormBuilderState> _request7FormKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> formData = {};

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  @override
  Widget build(BuildContext context) {

    bool isFormValid() {
      if (_request7FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
        return true;
      }
    return false;
    }

    void sendFormData() {
      formData.addAll(_request7FormKey.currentState!.value);
      
      // List<File> listFiles = files.map((file) => File(file.path!)).toList();
      List<String> listFiles = files.map((file) => file.name).toList();
      formData['file'] = listFiles;
      debugPrint(formData.toString());
    }

    return FormBuilder(
      key: _request7FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    "Sinh viên tải mẫu đơn bên dưới, điền đầy đủ thông tin "
                    "và đính kèm bản scan các giấy tờ xác nhận được hưởng trợ cấp. "
                    "Chú ý: nộp hồ sơ theo đúng thời hạn mà Nhà trường thông báo "
                    "vào đầu mỗi học kỳ. Sinh viên phải nộp bản gốc hồ sơ cho "
                    "Phòng 104-E3 trong vòng 05 ngày sau ngày nộp Online ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  TextButton(
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
                    onPressed: (){}
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
      ),
    );
  }
}
