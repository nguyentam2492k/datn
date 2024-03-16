import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_date_range_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Request6 extends StatefulWidget {
  const Request6({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request6State();
  }
}

class Request6State extends State<Request6> {

  final GlobalKey<FormBuilderState> _request6FormKey = GlobalKey<FormBuilderState>();

  bool isFormValid() {
    return _request6FormKey.currentState!.saveAndValidate();
  }

  Future<void> sendFormData() async {
    APIService apiService = APIService();
    Map<String, dynamic> formData = {};

    context.loaderOverlay.show();
    formData.addAll(_request6FormKey.currentState!.value);

    var request = Request(
      requestTypeId: 6, 
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
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.transparent,
      overlayWidgetBuilder: (progress) {
        return const LoadingHud();
      },
      child: FormBuilder(
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
                            name: 'documents', 
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isCollapsed: true,
                              errorStyle: TextStyle(
                                fontSize: 10,
                                height: 0.3
                              ),
                            ),
                            onSaved: (value) {
                              if (value != null && value.isEmpty) {
                                _request6FormKey.currentState!.fields["documents"]!.reset();
                              }
                            },
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
                        if (!_request6FormKey.currentState!.fields['documents']!.validate() && (value == null || value.isEmpty )) {
                          return "Điền hồ sơ khác nếu cần";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isEmpty) {
                          _request6FormKey.currentState!.fields["other_document"]!.reset();
                        }
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
                            name: 'borrow_date',
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
            SendRequestButton(
              onPressed: () async {
                isFormValid() ? await sendFormData() : null;
                setState(() {});
              }, 
            ),
          ],
        )
      ),
    );
  }
}