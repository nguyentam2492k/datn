import 'package:datn/widgets/custom_widgets/custom_date_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request11 extends StatefulWidget {
  const Request11({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request11State();
  }
}

class Request11State extends State<Request11> {

  final GlobalKey<FormBuilderState> _request11FormKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> formData = {};

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request11FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
      return true;
    }
    return false;
    // return files.isNotEmpty ? true : false;
  }

  void sendFormData() {
    formData.addAll(_request11FormKey.currentState!.value);
      
    // List<File> listFiles = files.map((file) => File(file.path!)).toList();
    List<String> listFiles = files.map((file) => file.name).toList();
    formData['file'] = listFiles;
    debugPrint(formData.toString());
  }

  @override
  Widget build(BuildContext context) {

    return FormBuilder(
      key: _request11FormKey,
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
                    "scan đơn, bảng điểm học tập và các giấy tờ khác "
                    "đính kèm vào yêu cầu; Sinh viên mang bản gốc "
                    "hồ sơ lên phòng 104-E3 để nộp và hoàn thành "
                    "các khoản học phí (trong thời gian 03 ngày kể từ ngày tạo yêu "
                    "cầu). Sau 05 ngày sinh viên lên nhận Quyết định.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
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
                  ),
                  const Divider(thickness: 0.4,),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Thời gian nghỉ:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomFormBuilderDateRangePicker(
                          name: 'date_range',
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          validator: (value) => (value == null) ? "Chọn thời gian chính xác" : null,
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 10,),
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
                    // onChanged: (value) {
                    //   setState(() {});
                    // },
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
            )
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