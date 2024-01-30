import 'package:datn/widgets/custom_widgets/custom_date_picker.dart';
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
  
  final List<String> documentTypes = [
    "Học bạ bản chính",
    "Bằng tốt nghiệp THPT (bản chính)",
    "Giấy triệu tập"
  ];

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
                  const Text(
                    "Sinh viên điền đầy đủ thông tin vào các trường "
                    "bên dưới và đến Phòng 104-E3 để mượn sau 02 ngày tạo yêu cầu.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(thickness: 0.4,),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Loại hồ sơ mượn",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: FormBuilderCheckboxGroup(
                          name: 'document_type', 
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                          validator: (value) {
                            var otherDocument = _request6FormKey.currentState!.fields['other_document']!.value;
                            if ((value == null || value.isEmpty) && (otherDocument == null || otherDocument.isEmpty)) {
                              return "Chọn hồ sơ";
                            }
                            return null;
                          },
                          options: documentTypes
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
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Thời gian mượn:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
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