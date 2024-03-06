import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:datn/widgets/custom_widgets/bottom_sheet_with_list.dart';
import 'package:datn/widgets/custom_widgets/numeric_step_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Request1 extends StatefulWidget {
  const Request1({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request1Stated();
  }
}

class Request1Stated extends State<Request1> {
  
  final GlobalKey<FormBuilderState> _request1FormKey = GlobalKey<FormBuilderState>();

  late String? selectedCertification;

  bool isCertificationValid = false;

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
      isCertificationValid && 
      numberOfCopy > 0 && 
      numberOfVietVer != null && 
      numberOfEngVer != null;
  }

  Future<void> sendFormData() async {

    APIService apiService = APIService();
    Map<String, dynamic> formData = {};

    context.loaderOverlay.show();
    formData.addAll(_request1FormKey.currentState!.value);
    formData.addAll({
      "certificate_type": selectedCertification,
      "quantity_viet": numberOfVietVer.toString(),
      "quantity_eng": numberOfEngVer.toString()
    });

    var request = Request(
      requestTypeId: 1, 
      documentNeed: null,
      fee: null,
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

  @override
  void initState() {
    super.initState();
    selectedCertification = null;
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
        key: _request1FormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      ConstantString.request1Note,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Divider(thickness: 0.4,),
                    SizedBox(
                      height: 65,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Loại giấy chứng nhận:",
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
                          const SizedBox(width: 5,),
                          Expanded(
                            flex: 4,
                            child: ElevatedButton.icon(
                              
                              icon: const Icon(Icons.arrow_drop_down),
                              label: Text(
                                selectedCertification ?? "Chọn Loại giấy chứng nhận",
                                maxLines: 2,  
                                overflow: TextOverflow.ellipsis,
                              ),
                              onPressed: () async {
                                final String? data = await openBottomSheet(selectedCertification);
                                if (data != null) {
                                  setState(() {
                                    selectedCertification = data;
                                    isCertificationValid = true;
                                  });
                                }
                              },
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
                    (isFormValid() && _request1FormKey.currentState!.saveAndValidate()) ? await sendFormData() : null;
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

  Future<dynamic> openBottomSheet(String? selectedItem) {
    String? selectedItemChanged = selectedItem;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      builder: (context) {
        return BottomSheetWithList(
          title: "Loại giấy chứng nhận",
          list: ConstantList.certificationList,
          selectedItem: selectedItemChanged,
        );
      },
    );
  }
}