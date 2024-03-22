import 'package:datn/constants/constant_list.dart';
import 'package:datn/constants/constant_string.dart';
import 'package:datn/model/enum/request_type.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:datn/widgets/custom_widgets/custom_dropdown_button.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request8 extends StatefulWidget {
  const Request8({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request8State();
  }
}

class Request8State extends State<Request8> {

  final GlobalKey<FormBuilderState> _request8FormKey = GlobalKey<FormBuilderState>();

  bool isFormValid() {
    return _request8FormKey.currentState!.saveAndValidate();
  }

  Future<void> sendFormData() async {

    APIService apiService = APIService();
    Map<String, dynamic> formData = {};

    formData.addAll(_request8FormKey.currentState!.value);
    
    await EasyLoading.show(status: "Đang gửi");

    try {
      await apiService.postDataWithoutFiles(formData: formData, requestType: RequestType.bankLoan).then((value) async {
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

    print(formData);
  }

  @override
  Widget build(BuildContext context) {
    
    return FormBuilder(
      key: _request8FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  Text(
                    ConstantString.request8Note,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                      child: const Text(
                        "Mẫu đơn",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                        ),
                      ),
                      onTap: () async {
                        await FileServices().actionDownloadFileWithUrl(
                          context, 
                          url: ConstantString.request8DocumentUrl
                        ).then((value) async {
                        });
                      },
                    ),
                  ),
                  const Divider(thickness: 0.4,),
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Học phí(đ) theo tháng",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const SizedBox(width: 4,),
                      Expanded(
                        flex: 2,
                        child: CustomFormBuilderDropdown(
                          name: 'tuition_type',
                          initialValue: ConstantList.monthFee[0],
                          items: ConstantList.monthFee
                            .map((fee) => DropdownMenuItem(
                              value: fee, 
                              child: Text(fee),
                            ))
                            .toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Chọn học phí";
                            }
                            return null;
                          },
                          valueTransformer: (value) {
                            final monthFeeIndex = ConstantList.monthFee.indexOf(value!) + 1;
                            return monthFeeIndex;
                          },
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: SizedBox()
                      )
                    ],
                  ),
                  const SizedBox(height: 10,)
                ],
              ),
            )
          ),
          SendRequestButton(
            onPressed: () async {
              isFormValid() ? await sendFormData() : null;
              setState(() {});
            },
          ),
        ],
      )
    );
  }
}