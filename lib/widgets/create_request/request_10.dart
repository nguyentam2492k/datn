import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:datn/widgets/custom_widgets/numeric_step_button.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';

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

  Future<void> sendFormData() async {

    APIService apiService = APIService();
    Map<String, dynamic> formData = {};

    context.loaderOverlay.show();
    formData.addAll({
      "quantity_viet": numberOfVietVer.toString(),
      "quantity_eng": numberOfEngVer.toString()
    });
    formData.addAll(_request10FormKey.currentState!.value);

    var request = Request(
      requestTypeId: 10, 
      documentNeed: null,
      fee: null,
      status: "completed", 
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
  void initState() {
    super.initState();
    numberOfVietVer = 1;
    numberOfEngVer= 0;
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
        key: _request10FormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      ConstantString.request10Note,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                    const SizedBox(height: 10,),
                  ],
                ),
              )
            ),
            SendRequestButton(
              onPressed: () async {
                (isFormValid() && _request10FormKey.currentState!.saveAndValidate()) ? await sendFormData() : null;
              },
            ),
          ],
        )
      ),
    );
  }
}