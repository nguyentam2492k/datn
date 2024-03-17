import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request20 extends StatefulWidget {
  const Request20({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request20State();
  }
}

class Request20State extends State<Request20> {

  final GlobalKey<FormBuilderState> _request20FormKey = GlobalKey<FormBuilderState>();

  bool isFormValid(){
    return _request20FormKey.currentState!.saveAndValidate();
  }

  Future<void> sendFormData() async {
    APIService apiService = APIService();
    Map<String, dynamic> formData = {};

    await EasyLoading.show(status: "Đang gửi");
    formData.addAll(_request20FormKey.currentState!.value);

    var request = Request(
      requestTypeId: 20, 
      documentNeed: null,
      fee: null,
      status: "completed", 
      dateCreate: DateTime.now().toString()
    );

    await apiService.postData(request: request, requestInfo: formData).then((value) async {
      await EasyLoading.dismiss();
      MyToast.showToast(
        isError: value != null,
        text: "Gửi thành công",
        errorText: "LỖI: $value"
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _request20FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Text(
                    ConstantString.request20Note,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(thickness: 0.4,),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Chương trình đào tạo:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: FormBuilderRadioGroup(
                          name: 'education_program', 
                          initialValue: ConstantList.educationPrograms[0],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Chọn chương trình đào tạo";
                            }
                            return null;
                          },
                          options: ConstantList.educationPrograms
                            .map((program) => FormBuilderFieldOption(value: program))
                            .toList(),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  CustomTextFieldRowWidget(
                    labelText: "Năm học:",
                    name: 'year',
                    isShort: true,
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