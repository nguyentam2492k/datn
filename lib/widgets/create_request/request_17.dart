import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/enum/request_type.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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

    formData.addAll(_request17FormKey.currentState!.value);

    await EasyLoading.show(status: "Đang gửi");

    try {
      await apiService.postDataWithoutFiles(formData: formData, requestType: RequestType.busCard).then((value) async {
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
  void initState() {
    super.initState();
    isEnable = true;
  }

  @override
  Widget build(BuildContext context) {

    return FormBuilder(
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
                        await FileServices().actionDownloadFileWithUrl(
                          context, 
                          url: ConstantString.request17DocumentUrl
                        ).then((value) async {
                          await EasyLoading.dismiss();
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
                              name: 'interline_bus_type', 
                              initialValue: ConstantList.busChoices[0],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                              onChanged: (value) {
                                isEnable = true;
                                if (_request17FormKey.currentState!.fields['interline_bus_type']!.value != ConstantList.busChoices[0]) {
                                  _request17FormKey.currentState!.fields['bus_number']!.reset();
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
                                          name: "bus_number",
                                          enabled: isEnable,
                                          validator: (value) {
                                            if (_request17FormKey.currentState!.fields['interline_bus_type']!.value == ConstantList.busChoices[0] && (value == null || value.isEmpty)) {
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
                              valueTransformer: (value) {
                                final busTypeIndex = ConstantList.busChoices.indexOf(value!) + 1;
                                return busTypeIndex;
                              },
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  CustomTextFieldRowWidget(
                    labelText: "Địa chỉ sinh viên:", 
                    name: 'address',
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
                    name: 'phone_number',
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
                    name: 'process_place',
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
    );
  }

}