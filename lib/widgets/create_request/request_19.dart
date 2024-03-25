import 'package:datn/constants/constant_string.dart';
import 'package:datn/function/function.dart';
import 'package:datn/model/enum/request_type.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:datn/widgets/custom_widgets/custom_date_range_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request19FormKey.currentState!.validate() && files.isNotEmpty) {
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
    
    final dateTimeRange = _request19FormKey.currentState?.fields['date_range']?.value as DateTimeRange;
    _request19FormKey.currentState?.removeInternalFieldValue("date_range");
    _request19FormKey.currentState?.save();
    
    formData.addAll({
      'start_date': dateTimeRange.start.toString(),
      'end_date': dateTimeRange.end.toString()
    });

    formData.addAll(_request19FormKey.currentState!.value);
    
    await EasyLoading.show(status: "Đang gửi");

    try {
      await apiService.postDataWithFiles(requestType: RequestType.houseRental, data: formData, files: files).then((value) async {
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
      key: _request19FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Text(
                    ConstantString.request19Note,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
                      onTap: () async {
                        await FileServices().actionDownloadFileWithUrl(
                          context, 
                          url: ConstantString.request19DocumentUrl
                        );
                      },
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
                    name: "priority", 
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
                    name: "phone_number", 
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
                    name: "contact_method", 
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