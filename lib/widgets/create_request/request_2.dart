import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:datn/widgets/custom_widgets/numeric_step_button.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';

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

  @override
  void initState() {
    super.initState();
    numberOfVietVer = 1;
    numberOfEngVer= 0;
  }

  @override
  Widget build(BuildContext context) {

  Map<String, dynamic> formData = {};

    Future<void> sendFormData() async {
      APIService apiService = APIService();
      context.loaderOverlay.show();
      formData.addAll(_request2FormKey.currentState!.value);
      formData.addAll({
        'quantity_viet': numberOfVietVer.toString(),
        'quantity_eng': numberOfEngVer.toString(),
      });

      var request = Request(
        requestTypeId: 2, 
        file: null,
        status: "processing", 
        dateCreate: DateTime.now().toString()
      );

      await apiService.postData(request: request, requestInfo: formData).then((value) {
        context.loaderOverlay.hide();
        CustomSnackBar().showSnackBar(
          context,
          isError: value != null,
          text: "Gửi thành công",
          errorText: "LỖI: $value"
        );
      });
      
    }

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.transparent,
      overlayWidgetBuilder: (progress) {
        return const LoadingHud();
      },
      child: FormBuilder(
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
                                    name: 'semester_type', 
                                    initialValue: ConstantList.termTypes[0],
                                    options: ConstantList.termTypes
                                    .map((termType) => FormBuilderFieldOption(value: termType))
                                    .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _request2FormKey.currentState?.fields['semester_number']?.reset();
                                      });
                                    },
                                  ),
                                ),
                                const Divider(thickness: 0.4,),
                                Expanded(
                                  child: FormBuilderCheckboxGroup(
                                    name: 'semester_number', 
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isCollapsed: true,
                                      errorStyle: TextStyle(
                                        fontSize: 10,
                                        height: 0.3
                                      ),
                                    ),
                                    enabled: _request2FormKey.currentState?.fields['semester_type']?.value == ConstantList.termTypes[1],
                                    validator: (value) {
                                      if (_request2FormKey.currentState?.fields['semester_type']?.value == ConstantList.termTypes[1] && (value == null || value.isEmpty)) {
                                        return "Chọn kỳ mong muốn";
                                      }
                                      return null;
                                    },
                                    options: ConstantList.termNumbers
                                      .map((termNumber) => FormBuilderFieldOption(value: termNumber))
                                      .toList(),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormValid() ? Colors.blue : Colors.grey,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () async { 
                    (isFormValid() && _request2FormKey.currentState!.saveAndValidate()) ? await sendFormData() : null;
                  }, 
                  label: const Text("Gửi yêu cầu"),
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
}