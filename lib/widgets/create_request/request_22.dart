import 'package:datn/constants/constant_list.dart';
import 'package:datn/function/function.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
        CustomSnackBar().showSnackBar(
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
    var loaderOverlay = context.loaderOverlay;
    
    loaderOverlay.show(progress: "Đang gửi");

    var request = Request(
      requestTypeId: 22, 
      status: "canceled", 
      documentNeed: null,
      fee: "10.000",
      dateCreate: DateTime.now().toString(),
    );
    
    try {
      await APIService().postDataWithFile(request: request, formData: _request22FormKey.currentState!.value, files: files).then((value) {
        loaderOverlay.hide();
        CustomSnackBar().showSnackBar(
          text: "Gửi thành công",
        );
      });
    } catch (e) {
      loaderOverlay.hide();
      CustomSnackBar().showSnackBar(
        isError: true,
        errorText: "LỖI: Gửi không thành công"
      );
    } 
  }
  
  @override
  Widget build(BuildContext context) {

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.transparent,
      overlayWidgetBuilder: (progress) {
        return LoadingHud(text: progress.toString(),);
      },
      child: FormBuilder(
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
                            name: 'education_program', 
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
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    CustomTextFieldRowWidget(
                      labelText: "Nơi thực tập:",
                      name: 'intern_company',
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
                  onPressed: () async {
                    isFileAdded = files.isEmpty ? false : true;
                    isFormValid() ? await sendFormData() : null;
                    setState(() {});
                  }, 
                  label: const Text("Gửi yêu cầu"),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
  
}