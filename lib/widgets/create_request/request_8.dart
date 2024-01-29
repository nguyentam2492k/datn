import 'package:datn/widgets/custom_widgets/custom_dropdown_button.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request8 extends StatefulWidget {
  const Request8({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request8State();
  }
}

class Request8State extends State<Request8> {

  final GlobalKey<FormBuilderState> _request8FormKey = GlobalKey<FormBuilderState>();

  List<String> monthFee = ['960000đ', '3000000đ', '3500000đ', '4200000đ'];

  Map<String, dynamic> formData = {};

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  @override
  Widget build(BuildContext context) {

    bool isFormValid() {
      if (_request8FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
        return true;
      }
    return false;
    }

    void sendFormData() {
    formData.addAll(_request8FormKey.currentState!.value);
      
    // List<File> listFiles = files.map((file) => File(file.path!)).toList();
    List<String> listFiles = files.map((file) => file.name).toList();
    formData['file'] = listFiles;
    debugPrint(formData.toString());
  }
    
    return FormBuilder(
      key: _request8FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    "Sinh viên : - Ghi rõ lý do; - Chọn mức học phí "
                    "theo thác của mình; - Cập nhật hồ sơ "
                    "(Thông tin về CCCD/CMND; ngày nhập học; ,..) "
                    "trước khi thực hiện yêu cầu này. Sinh viên tải mẫu đơn, "
                    "điền đầy đủ thông tin, scan và đính kèm vào phần bên dưới, "
                    "đến Phòng 104-E3 nhận kết quả sau 01 ngày làm việc.",
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
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Học phí(đ) theo tháng",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomFormBuilderDropdown(
                          name: 'month_fee',
                          initialValue: monthFee[0],
                          items: monthFee
                            .map((fee) => DropdownMenuItem(
                              value: fee, 
                              child: Text(fee),
                            ))
                            .toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Chọn học phí";
                            }
                            return null;
                          },
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: SizedBox()
                      )
                    ],
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