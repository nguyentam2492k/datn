import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/constants/my_icons.dart';
import 'package:datn/model/enum/request_type.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:datn/widgets/custom_widgets/bottom_sheet_with_list.dart';
import 'package:datn/widgets/custom_widgets/numeric_step_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request1 extends StatefulWidget {
  const Request1({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request1Stated();
  }
}

class Request1Stated extends State<Request1> {
  
  final GlobalKey<FormBuilderState> _request1FormKey = GlobalKey<FormBuilderState>();

  late int? selectedCertificationIndex;

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

    await EasyLoading.show(status: "Đang gửi");
    formData.addAll(_request1FormKey.currentState!.value);
    formData.addAll({
      "certificate_type": selectedCertificationIndex! + 1,
      "number_of_copies_vi": numberOfVietVer,
      "number_of_copies_en": numberOfEngVer
    });

    try {
      await apiService.postDataWithoutFiles(formData: formData, requestType: RequestType.certificate).then((value) async {
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

  String? getSelectedCertification(int? index) {
    if (index == null) {
      return null;
    }
    return ConstantList.certificationList[index];
  }

  @override
  void initState() {
    super.initState();
    selectedCertificationIndex = null;
    numberOfVietVer = 1;
    numberOfEngVer= 0;
  }

  @override
  Widget build(BuildContext context) {

    return FormBuilder(
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
                            
                            icon: const Icon(MyIcons.arrowDown),
                            label: Text(
                              getSelectedCertification(selectedCertificationIndex) ?? "Chọn Loại giấy chứng nhận",
                              maxLines: 2,  
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () async {
                              final String? data = await openBottomSheet(getSelectedCertification(selectedCertificationIndex));
                              if (data != null) {
                                setState(() {
                                  selectedCertificationIndex = ConstantList.certificationList.indexOf(data);
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
          SendRequestButton(
            isFormValid: isFormValid(),
            onPressed: () async {
              (isFormValid() && _request1FormKey.currentState!.saveAndValidate()) ? await sendFormData() : null;
            },
          )
        ],
      ),
    );
  }

  Future<String?> openBottomSheet(String? selectedItem) {
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