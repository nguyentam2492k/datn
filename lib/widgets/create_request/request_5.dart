import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_date_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Request5 extends StatefulWidget {
  const Request5({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request5State();
  }
}

class Request5State extends State<Request5> {

  final GlobalKey<FormBuilderState> _request5FormKey = GlobalKey<FormBuilderState>();

  DateTime currentDate = DateTime.now();

  bool isFormValid() {
    return _request5FormKey.currentState!.saveAndValidate();
  }

  Future<void> sendFormData() async {
    APIService apiService = APIService();
    Map<String, dynamic> formData = {};

    context.loaderOverlay.show();
    formData.addAll(_request5FormKey.currentState!.value);

    var request = Request(
      requestTypeId: 5, 
      documentNeed: null,
      fee: null,
      status: "processing", 
      dateCreate: currentDate.toString()
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
        key: _request5FormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      ConstantString.request5Note,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(thickness: 0.4,),
                    CustomTextFieldRowWidget(
                      labelText: "Học kỳ:", 
                      name: 'semester',
                      initialValue: (currentDate.month > 6) ? "2" : "1",
                      isShort: true,
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
                    CustomTextFieldRowWidget(
                      labelText: "Năm học:", 
                      name: 'year',
                      initialValue: (currentDate.month > 6) ? "${currentDate.year}-${currentDate.year + 1}" : "${currentDate.year - 1}-${currentDate.year}",
                      isShort: true,
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
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "Đến ngày:",
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
                          flex: 2,
                          child: CustomFormBuilderDateTimePicker(
                            name: 'until_date',
                            validator: (value) {
                              if (value == null) {
                                return "Chọn ngày chính xác";
                              }
                              return null;
                            },
                          )
                        ),
                        const Expanded(
                          flex: 2,
                          child: SizedBox(),
                        )
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
              ),
            ),
            SendRequestButton(
              onPressed: () async {
                isFormValid() ? await sendFormData() : null;
                setState(() {});
              }, 
            ),
          ],
        ),
      ),
    );
  }
}