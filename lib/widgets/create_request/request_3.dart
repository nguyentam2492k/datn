import 'dart:io';

import 'package:datn/constants/constant_string.dart';
import 'package:datn/global_variable/globals.dart';
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

  Map<String, dynamic> formData = {};

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  @override
  Widget build(BuildContext context) {

    bool isFormValid() {
      if (_request3FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
        return true;
      }
    return false;
    }

    bool isListFileOK(List<PlatformFile> listPlatformFile) {
      bool isFileOK = true;
      var listFileNull = listPlatformFile.where((element) => element.path == null).toList();
      for (var platformFile in listPlatformFile) {
        var file = File(platformFile.path!);
        if (!file.existsSync()) {
          isFileOK = false;
        }
      }
      return listFileNull.isEmpty && isFileOK;
    }

    Future<void> sendFormData() async {
      context.loaderOverlay.show();
      
      //TODO: TEST SEND MULTIPLE FILES

      List<String> listUrl = [];
      String child = "files/${globalLoginResponse!.user.id}/33";

      // files = testFile;

      if (isListFileOK(files)){
        await firebaseServices.uploadMultipleFileAndGetUrl(child: child, files: files)
          .then((value) {
            context.loaderOverlay.hide();
             CustomSnackBar().showSnackBar(
              context,
              isError: value.isEmpty,
              text: "Gửi thành công",
              errorText: "LỖI: Gửi không thành công"
            );
            // print(value);
            if (value.isEmpty) {
              return;
            }
            listUrl = value;
          });
      } else {
        context.loaderOverlay.hide();
        CustomSnackBar().showSnackBar(
          context,
          isError: true,
          errorText: "File lỗi"
        );
      }
      print("LIST URL - $listUrl");

      formData.addAll(_request3FormKey.currentState!.value);
      
      // List<File> listFiles = files.map((file) => File(file.path!)).toList();
      List<String> listFiles = files.map((file) => file.name).toList();
      formData['file'] = listFiles;
      debugPrint(formData.toString());
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