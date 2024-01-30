import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/numeric_step_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request10 extends StatefulWidget {
  const Request10({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request10State();
  }
}

class Request10State extends State<Request10> {

  final GlobalKey<FormBuilderState> _request10FormKey = GlobalKey<FormBuilderState>();

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

  void sendFormData() {
    formData.addAll(_request10FormKey.currentState!.value);
    formData.addAll({
      'quantity_viet': numberOfVietVer,
      'quantity_eng': numberOfEngVer,
    });
    debugPrint(formData.toString());
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
      key: _request10FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    "Sinh viên chỉ có thể xin chứng nhận sau "
                    "khi đã có Quyết định công nhận tốt nghiệp, "
                    "điền đầy đủ thông tin bên dưới, đến Phòng 104-E3 "
                    "nhận kết quả sau 15h chiều thứ Tư và thứ Sáu hàng tuần.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(thickness: 0.4,),
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
                      const SizedBox(width: 5,),
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
                      const SizedBox(width: 5,),
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
                  backgroundColor: isFormValid() ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white
                ),
                onPressed: () { 
                  (isFormValid() && _request10FormKey.currentState!.saveAndValidate()) ? sendFormData() : null;
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