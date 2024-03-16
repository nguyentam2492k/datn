import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Request17 extends StatefulWidget {
  const Request17({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request17State();
  }
}

class Request17State extends State<Request17> {

  final GlobalKey<FormBuilderState> _request17FormKey = GlobalKey<FormBuilderState>();

  late bool isEnable;
  
  bool isFormValid() {
    return _request17FormKey.currentState!.saveAndValidate();
  }

  Future<void> sendFormData() async {
    APIService apiService = APIService();
    Map<String, dynamic> formData = {};

    context.loaderOverlay.show(progress: "Đang gửi");
    formData.addAll(_request17FormKey.currentState!.value);

    var request = Request(
      requestTypeId: 17, 
      documentNeed: null,
      fee: null,
      status: "processing", 
      dateCreate: DateTime.now().toString()
    );

    await apiService.postData(request: request, requestInfo: formData).then((value) {
      context.loaderOverlay.hide();
      CustomSnackBar().showSnackBar(
        isError: value != null,
        text: "Gửi thành công",
        errorText: "LỖI: $value"
      );
    });
      
  }

  @override
  void initState() {
    super.initState();
    isEnable = true;
  }

  @override
  Widget build(BuildContext context) {

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.transparent,
      overlayWidgetBuilder: (progress) {
        return LoadingHud(text: progress.toString(),);
      },
      child: FormBuilder(
        key: _request17FormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      ConstantString.request17Note,
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
                          context.loaderOverlay.show(progress: "Chuẩn bị tải ");
                          await FileServices().actionDownloadFileWithUrl(
                            context, 
                            url: ConstantString.request17DocumentUrl
                          ).then((value) {
                            context.loaderOverlay.hide();
                          });
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
                                  text: "Tuyến buýt đăng ký:",
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
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              FormBuilderRadioGroup(
                                name: 'tuyen', 
                                initialValue: ConstantList.busChoices[0],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                ),
                                onChanged: (value) {
                                  isEnable = true;
                                  if (_request17FormKey.currentState!.fields['tuyen']!.value != ConstantList.busChoices[0]) {
                                    _request17FormKey.currentState!.fields['mottuyen']!.reset();
                                    FocusScope.of(context).unfocus();
                                    isEnable = false;
                                  }
                                  setState(() {
                                  });
                                },
                                options: [
                                  FormBuilderFieldOption(
                                    value: ConstantList.busChoices[0],
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          flex: 1,
                                          child: Text("Một tuyến số:")
                                        ),
                                        const SizedBox(width: 3,),
                                        Expanded(
                                          flex: 2,
                                          child: CustomFormBuilderTextField(
                                            name: "mottuyen",
                                            enabled: isEnable,
                                            validator: (value) {
                                              if (_request17FormKey.currentState!.fields['tuyen']!.value == ConstantList.busChoices[0] && (value == null || value.isEmpty)) {
                                                return "Nhập số tuyến";
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FormBuilderFieldOption(value: ConstantList.busChoices[1]),
                                  FormBuilderFieldOption(value: ConstantList.busChoices[2]),
                                ],
                              )
                            ],
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    CustomTextFieldRowWidget(
                      labelText: "Địa chỉ sinh viên:", 
                      name: 'student_address',
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
                    CustomTextFieldRowWidget(
                      labelText: "Điện thoại liên hệ:", 
                      name: 'phone_contact',
                      isShort: true,
                      keyboardType: TextInputType.phone,
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
                    CustomTextFieldRowWidget(
                      labelText: "Nơi nộp đơn và nhận thẻ:", 
                      name: 'receiving_place',
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
                  ],
                ),
              )
            ),
            SendRequestButton(
              onPressed: () async {
                isFormValid() ? await sendFormData() : null;
              }, 
            )
          ],
        )
      ),
    );
  }

}