import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/enum/request_type.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/numeric_step_button.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request2 extends StatefulWidget {
  const Request2({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return Request2State();
  }

}

class Request2State extends State<Request2> {

  final GlobalKey<FormBuilderState> _request2FormKey = GlobalKey<FormBuilderState>();

  late int? numberOfVietVer;
  late int? numberOfEngVer;

  bool isFormValid(){
    int numberOfCopy = 0;

    if (numberOfVietVer != null && numberOfVietVer! >= 0) {
      numberOfCopy += numberOfVietVer!;
    }

    if (numberOfEngVer != null && numberOfEngVer! >= 0) {
      numberOfCopy += numberOfEngVer!;
    }
    
    return 
      numberOfCopy > 0 &&
      numberOfVietVer != null && 
      numberOfEngVer != null;
  }

  Future<void> sendFormData() async {
    APIService apiService = APIService();
    Map<String, dynamic> formData = {};
    
    await EasyLoading.show(status: "Đang gửi");
    formData.addAll(_request2FormKey.currentState!.value);
    formData.addAll({
      'number_of_copies_vi': numberOfVietVer,
      'number_of_copies_en': numberOfEngVer,
    });

    try {
      await apiService.postDataWithoutFiles(formData: formData, requestType: RequestType.transcript).then((value) async {
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
    numberOfVietVer = 1;
    numberOfEngVer= 0;
  }

  @override
  Widget build(BuildContext context) {

    return FormBuilder(
      key: _request2FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Text(
                    ConstantString.request2Note,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(thickness: 0.4,),
                  const SizedBox(height: 2,),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "Kỳ:",
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
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                height: 40,
                                child: FormBuilderRadioGroup(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none, 
                                    isCollapsed: true,
                                  ),
                                  name: 'is_all_semesters', 
                                  initialValue: ConstantList.termTypes[1],
                                  options: ConstantList.termTypes
                                    .map((termType) => FormBuilderFieldOption(value: termType))
                                    .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _request2FormKey.currentState?.fields['semesters']?.reset();
                                    });
                                  },
                                  valueTransformer: (value) {
                                    final termTypesIndex = ConstantList.termTypes.indexOf(value!);
                                    return termTypesIndex;
                                  },
                                ),
                              ),
                              const Divider(thickness: 0.4,),
                              Expanded(
                                child: FormBuilderCheckboxGroup(
                                  name: 'semesters', 
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    errorStyle: TextStyle(
                                      fontSize: 10,
                                      height: 0.3
                                    ),
                                  ),
                                  enabled: _request2FormKey.currentState?.fields['is_all_semesters']?.value == "Từng kỳ",
                                  validator: (value) {
                                    if (_request2FormKey.currentState?.fields['is_all_semesters']?.value == "Từng kỳ" && (value == null || value.isEmpty)) {
                                      return "Chọn kỳ mong muốn";
                                    }
                                    return null;
                                  },
                                  options: ConstantList.termNumbers
                                    .map((termNumber) => FormBuilderFieldOption(value: termNumber, child: Text("Học kỳ $termNumber"),))
                                    .toList(),
                                  valueTransformer: (value) {
                                    if (value == null) {
                                      return <int>[];
                                    }
                                    final intList = value.map(int.parse).toList();
                                    return intList;
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Loại bảng điểm:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: FormBuilderRadioGroup(
                            decoration: const InputDecoration(
                              border: InputBorder.none, 
                              isCollapsed: true,
                            ),
                            name: 'transcript_type', 
                            initialValue: ConstantList.transcriptTypes[0],
                            options: ConstantList.transcriptTypes
                              .map((transcriptType) => FormBuilderFieldOption(value: transcriptType))
                              .toList(),
                            valueTransformer: (value) {
                              final transcriptTypeIndex = ConstantList.transcriptTypes.indexOf(value!) + 1;
                              return transcriptTypeIndex;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Số bản tiếng Việt:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const SizedBox(width: 12,),
                      Expanded(
                        flex: 4,
                        child: NumericStepButton(
                          initialValue: 1, 
                          minValue: 0, 
                          maxValue: 10, 
                          onChanged: (value) {
                            setState(() {
                              numberOfVietVer = value;
                            });
                          }
                        ),
                      ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Số bản tiếng Anh:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const SizedBox(width: 12,),
                      Expanded(
                        flex: 4,
                        child: NumericStepButton(
                          initialValue: 0, 
                          minValue: 0, 
                          maxValue: 10,
                          onChanged: (value) {
                            setState(() {
                              numberOfEngVer = value;
                            });
                            
                          }
                        ),
                      ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextFieldRowWidget(
                      labelText: "Lý do:", 
                      name: "reason", 
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
                  ),
                ],
              ),
            ),
          ),
          SendRequestButton(
            isFormValid: isFormValid(),
            onPressed: () async { 
              (isFormValid() && _request2FormKey.currentState!.saveAndValidate()) ? await sendFormData() : null;
            }, 
          ),
        ],
      ),
    );

  }
}