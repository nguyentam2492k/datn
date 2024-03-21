import 'package:datn/constants/constant_string.dart';
import 'package:datn/function/function.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request16 extends StatefulWidget {
  const Request16({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request16State();
  }
}

class Request16State extends State<Request16> {

  final GlobalKey<FormBuilderState> _request16FormKey = GlobalKey<FormBuilderState>();

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request16FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
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

    await EasyLoading.show(status: "Đang gửi");

    // var request = Request(
    //   requestTypeId: 16, 
    //   status: "processing", 
    //   documentNeed: null,
    //   fee: "10.000",
    //   dateCreate: DateTime.now().toString(),
    // );
    
    // try {
    //   await APIService().postDataWithFile(request: request, formData: _request16FormKey.currentState!.value, files: files).then((value) async {
    //     await EasyLoading.dismiss();
    //     MyToast.showToast(
    //       text: "Gửi thành công",
    //     );
    //   });
    // } catch (e) {
    //   await EasyLoading.dismiss();
    //   MyToast.showToast(
    //     isError: true,
    //     errorText: "LỖI: Gửi không thành công"
    //   );
    // } 
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _request16FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Text(
                    ConstantString.request16Note,
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
                          url: ConstantString.request16DocumentUrl
                        );
                      },
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