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

  final List<String> busChoices = [
    "Một tuyến",
    "Liên tuyến bình thường (không đi tuyến 54)",
    "Liên tuyến và tuyến 54 (tất cả các tuyến)",
  ];

  void sendFormData() {
    _request17FormKey.currentState!.saveAndValidate() ? debugPrint(_request17FormKey.currentState?.value.toString()) : null;
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
                  const Text(
                    "Sinh viên điền đầy đủ, chính xác thông tin; chuẩn bị "
                    "02 ảnh 2x3 để dán vào đơn, lấy dấu gáp lai của Trường.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                      onTap: (){debugPrint("Tap Mau don");},
                    ),
                  ),
                  const Divider(thickness: 0.4,),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Tuyến buýt đăng ký:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            FormBuilderRadioGroup(
                              name: 'tuyen', 
                              initialValue: busChoices[0],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                              onChanged: (value) {
                                // _request17FormKey.currentState!.fields['mottuyen']!.reset();
                                // FocusScope.of(context).unfocus();
                                if (_request17FormKey.currentState!.fields['tuyen']!.value != busChoices[0]) {
                                  _request17FormKey.currentState!.fields['mottuyen']!.reset();
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              options: [
                                FormBuilderFieldOption(
                                  value: busChoices[0],
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
                                          validator: (value) {
                                            if (_request17FormKey.currentState!.fields['tuyen']!.value == busChoices[0] && (value == null || value.isEmpty)) {
                                              return "Nhập số tuyến";
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                FormBuilderFieldOption(value: busChoices[1]),
                                FormBuilderFieldOption(value: busChoices[2]),
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