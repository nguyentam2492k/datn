import 'package:datn/constants/constant_string.dart';
import 'package:datn/function/function.dart';
import 'package:datn/model/enum/request_type.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_date_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request3 extends StatefulWidget {
  const Request3({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return Request3State();
  }

}

class Request3State extends State<Request3> {

  final GlobalKey<FormBuilderState> _request3FormKey = GlobalKey<FormBuilderState>();

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request3FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
      if (!isListFileOK(files)) {
        MyToast.showToast(
          isError: true,
          errorText: "File lỗi"
        );
        return false;
      }
      return true;
    }
    return false;
  }

  Future<void> sendFormData() async {

    APIService apiService = APIService();
    Map<String, dynamic> formData = {};
    
    await EasyLoading.show(status: "Đang gửi");
    formData.addAll(_request3FormKey.currentState!.value);

    try {
      await apiService.postDataWithFiles(requestType: RequestType.pauseExam, data: formData, files: files).then((value) async {
        await EasyLoading.dismiss();
        MyToast.showToast(
          text: "Gửi xong"
        );
      });
    } catch (e) {
      await EasyLoading.dismiss();
      MyToast.showToast(
        isError: true,
        errorText: "LỖI: ${e.toString()}"
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return FormBuilder(
      key: _request3FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Text(
                    ConstantString.request3Note,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(thickness: 0.4,),
                  CustomTextFieldRowWidget(
                    labelText: "Môn học:", 
                    name: "subject_name", 
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
                  CustomTextFieldRowWidget(
                    labelText: "Giảng viên giảng dạy:", 
                    name: "teacher_name", 
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
                                  text: "Ngày thi:",
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
                        flex: 2,
                        child: CustomFormBuilderDateTimePicker(
                          name: 'exam_date',
                          validator: (value) {
                            if (value == null) {
                              return "Chọn ngày chính xác";
                            }
                            return null;
                          },
                        )
                      ),
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  CustomTextFieldRowWidget(
                    labelText: "Lý do", 
                    name: "reason", 
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty ) {
                        return "Điền đầy đủ thông tin!";
                      }
                      return null;
                    }, 
                    onChanged: (value) { setState(() {
                    }); },
                  ),
                  const SizedBox(height: 8,),
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
          SendRequestButton(
            onPressed: () async {
              isFileAdded = files.isEmpty ? false : true;
              isFormValid() ? await sendFormData() : null;
              setState(() {});
            }, 
          )
        ],
      )
    );
  }
}