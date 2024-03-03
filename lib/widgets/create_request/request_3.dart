import 'package:datn/constants/constant_string.dart';
import 'package:datn/function/function.dart';
import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/request/file_data_model.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/services/firebase/firebase_services.dart';
import 'package:datn/widgets/custom_widgets/custom_date_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:uuid/v1.dart';

class Request3 extends StatefulWidget {
  const Request3({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return Request3State();
  }

}

class Request3State extends State<Request3> {

  final GlobalKey<FormBuilderState> _request3FormKey = GlobalKey<FormBuilderState>();

  FirebaseServices firebaseServices = FirebaseServices();

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  @override
  Widget build(BuildContext context) {

    bool isFormValid() {
      if (_request3FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
        if (!isListFileOK(files)) {
          CustomSnackBar().showSnackBar(
            context,
            isError: true,
            errorText: "File lỗi"
          );
          return false;
        }
        return true;
      }
      return false;
    }

    Future<void> postDataToApi({required List<FileData> listFileData}) async {
      APIService apiService = APIService();
      Map<String, dynamic> formData = {};

      formData.addAll(_request3FormKey.currentState!.value);

      var request = Request(
        requestTypeId: 1, 
        status: "processing", 
        file: listFileData,
        dateCreate: DateTime.now().toString()
      );

      await apiService.postData(request: request, requestInfo: formData)
        .then((value) {
          context.loaderOverlay.hide();
          CustomSnackBar().showSnackBar(
            context,
            isError: value != null,
            text: "Gửi thành công",
            errorText: "LỖI: $value"
          );
        });
    }

    Future<void> sendFormData() async {
      context.loaderOverlay.show();
      
      //TODO: TEST SEND MULTIPLE FILES

      List<FileData> listFileData = [];
      String child = "files/${globalLoginResponse!.user.id}/${const UuidV1().generate()}";

      await firebaseServices.uploadMultipleFile(child: child, files: files)
        .then((value) async {          
          if (value.isEmpty) {
            context.loaderOverlay.hide();
            CustomSnackBar().showSnackBar(
              context,
              isError: true,
              errorText: "LỖI: Gửi không thành công"
            );
            return;
          }
          listFileData = value;
          await postDataToApi(listFileData: listFileData);
        });
      
    }

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.transparent,
      overlayWidgetBuilder: (progress) {
        return const LoadingHud();
      },
      child: FormBuilder(
        key: _request3FormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      ConstantString.request3Note,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(thickness: 0.4,),
                    CustomTextFieldRowWidget(
                      labelText: "Môn học:", 
                      name: "subject", 
                      validator: (value) {
                        if (value == null || value.isEmpty ) {
                          return "Điền đầy đủ thông tin!";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      }
                    ),
                    const SizedBox(height: 10,),
                    CustomTextFieldRowWidget(
                      labelText: "Giảng viên giảng dạy:", 
                      name: "lecturer", 
                      validator: (value) {
                        if (value == null || value.isEmpty ) {
                          return "Điền đầy đủ thông tin!";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {});
                      }
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
                                    text: "Ngày thi:",
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
                            name: 'exam_date',
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
                      labelText: "Lý do", 
                      name: "reason", 
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty ) {
                          return "Điền đầy đủ thông tin!";
                        }
                        return null;
                      }, 
                      onChanged: (value) { setState(() {
                      }); },
                    ),
                    const SizedBox(height: 5,),
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