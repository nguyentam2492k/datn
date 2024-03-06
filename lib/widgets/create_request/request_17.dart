import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
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

  void sendFormData() {
    _request17FormKey.currentState!.saveAndValidate() ? print(_request17FormKey.currentState?.value.toString()) : null;
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
                      onTap: (){print("Tap Mau don");},
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
                    name: 'contact',
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
                    name: 'receiving_address',
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
                  sendFormData();
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