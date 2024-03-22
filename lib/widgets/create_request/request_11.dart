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

class Request11 extends StatefulWidget {
  const Request11({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request11State();
  }
}

class Request11State extends State<Request11> {

  final GlobalKey<FormBuilderState> _request11FormKey = GlobalKey<FormBuilderState>();

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request11FormKey.currentState!.validate() && files.isNotEmpty) {
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

    final dateTimeRange = _request11FormKey.currentState?.fields['date_range']?.value as DateTimeRange;
    _request11FormKey.currentState?.removeInternalFieldValue("date_range");
    _request11FormKey.currentState?.save();
    
    formData.addAll({
      'start_date': dateTimeRange.start.toString(),
      'end_date': dateTimeRange.end.toString()
    });

    formData.addAll(_request11FormKey.currentState!.value);

    await EasyLoading.show(status: "Đang gửi");

    try {
      await apiService.postDataWithFiles(requestType: RequestType.timeLimitedAbsence, data: formData, files: files).then((value) async {
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
      key: _request11FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Text(
                    ConstantString.request11Note,
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
                          url: ConstantString.request11DocumentUrl
                        );
                      },
                    ),
                  ),
                  const Divider(thickness: 0.4,),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Thời gian nghỉ:",
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