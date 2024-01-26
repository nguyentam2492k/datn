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

  final List<String> termTypes = [
    "Tất cả",
    "Từng kỳ",
  ];

  final List<String> termNumbers = [
    "Học kỳ 1",
    "Học kỳ 2",
    "Học kỳ 3",
    "Học kỳ 4",
    "Học kỳ 5",
    "Học kỳ 6",
    "Học kỳ 7",
    "Học kỳ 8",
    "Học kỳ 9",
  ];

  final List<String> transcriptTypes = [
    "Chữ hệ số 4",
    "Số hệ số 10",
  ];

  final GlobalKey<FormBuilderState> _request2FormKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> formData = {};

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

    void sendFormData() {
      if (_request2FormKey.currentState!.saveAndValidate()) {
        formData.addAll(_request2FormKey.currentState!.value);
        formData.addAll({
          'quantity_viet': numberOfVietVer,
          'quantity_eng': numberOfEngVer,
        });
        debugPrint(formData.toString());
      }
    }

    return FormBuilder(
      key: _request2FormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Kỳ:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          )
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
                                  initialValue: termTypes[0],
                                  options: termTypes
                                  .map((termType) => FormBuilderFieldOption(value: termType))
                                  .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _request2FormKey.currentState!.fields['term_number']!.reset();
                                    });
                                  },
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: FormBuilderCheckboxGroup(
                                  name: 'term_number', 
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                  ),
                                  enabled: _request2FormKey.currentState?.fields['term_type']?.value == termTypes[1],
                                  validator: (value) {
                                    if (_request2FormKey.currentState?.fields['term_type']?.value == termTypes[1] && (value == null || value.isEmpty)) {
                                      return "Chọn kỳ mong muốn";
                                    }
                                    return null;
                                  },
                                  options: termNumbers
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
                            initialValue: transcriptTypes[0],
                            // validator: (value) {
                              
                            // },
                            options: transcriptTypes
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
                    height: MediaQuery.of(context).size.height * 0.25,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Lý do:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          flex: 4,
                          child: FormBuilderTextField(
                            name: "reason",
                            maxLines: 100,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 0.3,
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                            ),
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