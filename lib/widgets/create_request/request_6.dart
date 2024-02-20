import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/widgets/custom_widgets/custom_date_range_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request6 extends StatefulWidget {
  const Request6({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request6State();
  }
}

class Request6State extends State<Request6> {

  final GlobalKey<FormBuilderState> _request6FormKey = GlobalKey<FormBuilderState>();

  void sendFormData() {
    _request6FormKey.currentState!.saveAndValidate() ? debugPrint(_request6FormKey.currentState?.value.toString()) : null;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _request6FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Text(
                    ConstantString.request6Note,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
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
                                  text: "Loại hồ sơ mượn:",
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
                        child: FormBuilderCheckboxGroup(
                          name: 'document_type', 
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                            errorStyle: TextStyle(
                              fontSize: 10,
                              height: 0.3
                            ),
                          ),
                          validator: (value) {
                            var otherDocument = _request6FormKey.currentState!.fields['other_document']!.value;
                            if ((value == null || value.isEmpty) && (otherDocument == null || otherDocument.isEmpty)) {
                              return "Chọn hồ sơ";
                            }
                            return null;
                          },
                          options: ConstantList.documentTypes
                            .map((documentType) => FormBuilderFieldOption(value: documentType))
                            .toList(),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  CustomTextFieldRowWidget(
                    labelText: "Hồ sơ khác:",
                    name: 'other_document',
                    isImportant: false,
                    validator: (value) {
                      if (!_request6FormKey.currentState!.fields['document_type']!.validate() && (value == null || value.isEmpty )) {
                        return "Điền hồ sơ khác nếu cần";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child:RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Thời gian mượn:",
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