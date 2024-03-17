import 'package:datn/constants/constant_string.dart';
import 'package:datn/function/function.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:datn/widgets/custom_widgets/custom_dropdown_button.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  @override
  Widget build(BuildContext context) {

    bool isFormValid() {
      if (_request8FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
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

      var request = Request(
        requestTypeId: 8, 
        status: "canceled", 
        documentNeed: null,
        fee: "5.000",
        dateCreate: DateTime.now().toString(),
      );
      
      try {
        await APIService().postDataWithFile(request: request, formData: _request8FormKey.currentState!.value, files: files).then((value) async {
          await EasyLoading.dismiss();
          MyToast.showToast(
            text: "Gửi thành công",
          );
        });
      } catch (e) {
        await EasyLoading.dismiss();
        MyToast.showToast(
          isError: true,
          errorText: "LỖI: Gửi không thành công"
        );
      } 
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
                  Text(
                    ConstantString.request8Note,
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
                          url: ConstantString.request8DocumentUrl
                        ).then((value) async {
                        });
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
                      const SizedBox(width: 4,),
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
            },
          ),
        ],
      )
    );
  }
}