import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request13 extends StatefulWidget {
  const Request13({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request13State();
  }
}

class Request13State extends State<Request13> {

  final GlobalKey<FormBuilderState> _request13FormKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> formData = {};

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request13FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
      return true;
    }
    return false;
  }

  void sendFormData() {
    formData.addAll(_request13FormKey.currentState!.value);
      
    // List<File> listFiles = files.map((file) => File(file.path!)).toList();
    List<String> listFiles = files.map((file) => file.name).toList();
    formData['file'] = listFiles;
    debugPrint(formData.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _request13FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    "Sinh viên tải mẫu đơn, điền đầy đủ thông tin, "
                    "xin ý kiến của phụ huynh, xác nhận của chính quyền địa phương, "
                    "xin ý kiến của Ban chủ nhiệm khoa, scan đơn và "
                    "đính kèm vào yêu cầu; Sinh viên mang bản gốc "
                    "hồ sơ lên phòng 104-E3 để nộp và hoàn thành các "
                    "khoản kinh phí (trong thời gian 03 ngày kể từ ngày tạo yêu cầu). "
                    "Sau 05 ngày sinh viên lên nhận Quyết định và rút hồ sơ.",
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
                            "Phiếu thanh toán",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                          ),
                          onTap: (){debugPrint("Tap Mau don");},
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