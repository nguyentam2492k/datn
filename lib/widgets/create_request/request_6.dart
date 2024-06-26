import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/enum/request_type.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_date_range_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  bool isFormValid() {
    return _request6FormKey.currentState!.validate();
  }

  Future<void> sendFormData() async {
    APIService apiService = APIService();
    Map<String, dynamic> formData = {};

    await EasyLoading.show(status: "Đang gửi");

    final dateTimeRange = _request6FormKey.currentState?.fields['date_range']?.value as DateTimeRange;
    _request6FormKey.currentState?.removeInternalFieldValue("date_range");
    _request6FormKey.currentState?.save();
    
    formData.addAll({
      'start_date': dateTimeRange.start.toString(),
      'end_date': dateTimeRange.end.toString()
    });

    formData.addAll(_request6FormKey.currentState!.value);

    try {
      await apiService.postDataWithoutFiles(formData: formData, requestType: RequestType.borrowFile).then((value) async {
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
                          name: 'file_types', 
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                            errorStyle: TextStyle(
                              fontSize: 10,
                              height: 0.3
                            ),
                          ),
                          validator: (value) {
                            var otherDocument = _request6FormKey.currentState?.fields['other_file']?.value as String?;
                            if ((value == null || value.isEmpty) && (otherDocument == null || otherDocument.trim().isEmpty)) {
                              return "Chọn loại hồ sơ";
                            }
                            return null;
                          },
                          options: ConstantList.documentTypes
                            .map((documentType) => FormBuilderFieldOption(value: documentType))
                            .toList(),
                          valueTransformer: (value) {
                            if (value != null) {
                              final valueIndex = value.map((e) => ConstantList.documentTypes.indexOf(e) + 1).toList();
                              valueIndex.sort();
                              return valueIndex;
                            }
                            return [];
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  CustomTextFieldRowWidget(
                    labelText: "Hồ sơ khác:",
                    name: 'other_file',
                    isImportant: false,
                    validator: (value) {
                      final documentValue = _request6FormKey.currentState?.fields['file_types']?.value as List<dynamic>?;
                      if ((documentValue == null || documentValue.isEmpty) && (value == null || value.trim().isEmpty )) {
                        return "Điền hồ sơ khác nếu cần";
                      }
                      return null;
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
          SendRequestButton(
            onPressed: () async {
              isFormValid() ? await sendFormData() : null;
              setState(() {});
            }, 
          ),
        ],
      )
    );
  }
}