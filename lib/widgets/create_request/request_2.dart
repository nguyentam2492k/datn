import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/numeric_step_button.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    numberOfVietVer = 1;
    numberOfEngVer= 0;
  }

  @override
  Widget build(BuildContext context) {

  Map<String, dynamic> formData = {};

    void sendFormData() {
      formData.addAll(_request2FormKey.currentState!.value);
      formData.addAll({
        'quantity_viet': numberOfVietVer,
        'quantity_eng': numberOfEngVer,
      });
      debugPrint(formData.toString());
    }

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
                                  name: 'term_type', 
                                  initialValue: ConstantList.termTypes[0],
                                  options: ConstantList.termTypes
                                  .map((termType) => FormBuilderFieldOption(value: termType))
                                  .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _request2FormKey.currentState!.fields['term_number']!.reset();
                                    });
                                  },
                                ),
                              ),
                              const Divider(thickness: 0.4,),
                              Expanded(
                                child: FormBuilderCheckboxGroup(
                                  name: 'term_number', 
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    errorStyle: TextStyle(
                                      fontSize: 10,
                                      height: 0.3
                                    ),
                                  ),
                                  enabled: _request2FormKey.currentState?.fields['term_type']?.value == ConstantList.termTypes[1],
                                  validator: (value) {
                                    if (_request2FormKey.currentState?.fields['term_type']?.value == ConstantList.termTypes[1] && (value == null || value.isEmpty)) {
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
                            // validator: (value) {
                              
                            // },
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
                onPressed: () { 
                  (isFormValid() && _request2FormKey.currentState!.saveAndValidate()) ? sendFormData() : null;
                }, 
                label: const Text("Gửi yêu cầu"),
              ),
            ),
          )
        ],
      ),
    );

  }
}