import 'package:datn/widgets/custom_widgets/custom_date_range_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request19 extends StatefulWidget {
  const Request19({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request19State();
  }
}

class Request19State extends State<Request19> {

  final GlobalKey<FormBuilderState> _request19FormKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> formData = {};

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request19FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
      return true;
    }
    return false;
  }

  void sendFormData() {
    formData.addAll(_request19FormKey.currentState!.value);
      
    // List<File> listFiles = files.map((file) => File(file.path!)).toList();
    List<String> listFiles = files.map((file) => file.name).toList();
    formData['file'] = listFiles;
    debugPrint(formData.toString());
  }
  
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _request19FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    "Sinh viên điền đầy đủ thông tin, đính kèm minh chứng "
                    "(nếu thuộc diện ưu tiên); chuẩn bị ảnh 3x4 để dán đơn khi xác nhận.",
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
                  const Text(
                    "Đề nghị được thuê phòng Khu nhà ở sinh viên Mỹ Đình II "
                    "(đính kèm tệp minh chứng nếu thuộc diện ưu tiên):",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  CustomTextFieldRowWidget(
                    labelText: "Đơn nguyên đề nghị:", 
                    name: "name", 
                    validator: (value) {
                      if (value == null || value.isEmpty ) {
                        return "Điền đầy đủ thông tin!";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    }
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Thời gian thuê:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                              ),
                              TextSpan(
                                text: " *",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red
                                ),
                              ),
                            ]
                          )
                        ),
                      ),
                      const SizedBox(width: 4,),
                      Expanded(
                        flex: 3,
                        child: CustomFormBuilderDateRangePicker(
                          name: 'date_range',
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          initialValue: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                          validator: (value) => (value == null) ? "Chọn thời gian chính xác" : null,
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  const Divider(thickness: 0.4,),
                  const Text(
                    "Thông tin cá nhân",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const CustomTextFieldRowWidget(
                    labelText: "Đối tượng ưu tiên:", 
                    name: "doituonguutien", 
                    isImportant: false,
                  ),
                  const SizedBox(height: 10,),
                  const CustomTextFieldRowWidget(
                    labelText: "Địa chỉ thường trú:", 
                    name: "address", 
                    isImportant: false,
                  ),
                  const SizedBox(height: 10,),
                  const CustomTextFieldRowWidget(
                    labelText: "Điện thoại liên hệ:", 
                    name: "phone_contact", 
                    isImportant: false,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10,),
                  const CustomTextFieldRowWidget(
                    labelText: "Email:", 
                    name: "email", 
                    isImportant: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10,),
                  const CustomTextFieldRowWidget(
                    labelText: "Khi cần liên hệ (báo tin cho):", 
                    name: "khicanbaotin", 
                    isImportant: false,
                  ),
                  const SizedBox(height: 5,),
                  const Divider(thickness: 0.4,),
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