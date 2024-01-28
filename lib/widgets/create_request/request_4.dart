import 'package:datn/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request4 extends StatefulWidget {
  const Request4({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request4State();
  }
}

class Request4State extends State<Request4> {

  final GlobalKey<FormBuilderState> _request4FormKey = GlobalKey<FormBuilderState>();

  DateTime currentDate = DateTime.now();

  void sendFormData() {
    _request4FormKey.currentState!.saveAndValidate() ? debugPrint(_request4FormKey.currentState!.value.toString()) : null;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _request4FormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    "Sinh viên điền đầy đủ thông tin vào các trường bên dưới, "
                    "kết quả được thông báo trên Website khi hoàn tất",
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
                          "Học phần xin xem lại:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: CustomFormBuilderTextField(
                          name: 'subject_review',
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
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Học kỳ:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomFormBuilderTextField(
                          name: 'semester',
                          initialValue: (currentDate.month > 6) ? "2" : "1",
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
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Năm học:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: CustomFormBuilderTextField(
                          name: 'year',
                          initialValue: (currentDate.month > 6) ? "${currentDate.year}-${currentDate.year + 1}" : "${currentDate.year - 1}-${currentDate.year}",
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
                      const Expanded(
                        flex: 2,
                        child: SizedBox(),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
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
                        Expanded(
                          flex: 4,
                          child: CustomFormBuilderTextField(
                            name: "reason",
                            maxLines: 100,
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
      ),
    );
  }
}