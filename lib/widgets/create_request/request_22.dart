import 'package:datn/constants/constant_list.dart';
import 'package:datn/function/function.dart';
import 'package:datn/model/enum/request_type.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request22 extends StatefulWidget {
  const Request22({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request22State();
  }
  
}

class Request22State extends State<Request22> {

  final GlobalKey<FormBuilderState> _request22FormKey = GlobalKey<FormBuilderState>();

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid(){
    if (_request22FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
      if (!isListFileOK(files)) {
        MyToast.showToast(
          isError: true,
          errorText: "File lỗi"
        );
        return false;
      }
      return true;
    }
    return false;
  }

  Future<void> sendFormData() async {

    APIService apiService = APIService();
    Map<String, dynamic> formData = {};
    
    await EasyLoading.show(status: "Đang gửi");

    formData.addAll(_request22FormKey.currentState!.value);
    
    await EasyLoading.show(status: "Đang gửi");

    try {
      await apiService.postDataWithFiles(requestType: RequestType.introduceStudent, data: formData, files: files).then((value) async {
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
  
  @override
  Widget build(BuildContext context) {

    return FormBuilder(
      key: _request22FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Chương trình đào tạo:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: FormBuilderRadioGroup(
                          name: 'learning_program', 
                          initialValue: ConstantList.educationPrograms[0],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Chọn chương trình đào tạo";
                            }
                            return null;
                          },
                          options: ConstantList.educationPrograms
                            .map((program) => FormBuilderFieldOption(value: program))
                            .toList(),
                          valueTransformer: (value) {
                            final learningProgramIndex = ConstantList.educationPrograms.indexOf(value!) + 1;
                            return learningProgramIndex;
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  CustomTextFieldRowWidget(
                    labelText: "Nơi thực tập:",
                    name: 'practice_place',
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
                  const SizedBox(height: 8,),
                  CustomUploadFileRowWidget(
                    files: files, 
                    isFileAdded: isFileAdded, 
                    onChanged: (List<PlatformFile> value) { 
                      files = value;
                      setState(() {});
                    }, 
                  )
                ],
              ),
            )
          ),
          SendRequestButton(
            onPressed: () async {
              isFileAdded = files.isEmpty ? false : true;
              isFormValid() ? await sendFormData() : null;
              setState(() {});
            }, 
          )
        ],
      )
    );
  }
  
}