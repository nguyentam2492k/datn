import 'package:datn/constants/constant_string.dart';
import 'package:datn/function/function.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Request12 extends StatefulWidget {
  const Request12({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request12State();
  }
}

class Request12State extends State<Request12> {

  final GlobalKey<FormBuilderState> _request12FormKey = GlobalKey<FormBuilderState>();

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request12FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
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
    var loaderOverlay = context.loaderOverlay;
    
    loaderOverlay.show(progress: "Đang gửi");

    var request = Request(
      requestTypeId: 12, 
      status: "processing", 
      documentNeed: null,
      fee: "20.000",
      dateCreate: DateTime.now().toString(),
    );
    
    try {
      await APIService().postDataWithFile(request: request, formData: _request12FormKey.currentState!.value, files: files).then((value) {
        loaderOverlay.hide();
        MyToast.showToast(
          text: "Gửi thành công",
        );
      });
    } catch (e) {
      loaderOverlay.hide();
      MyToast.showToast(
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
        key: _request12FormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      ConstantString.request12Note,
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
                          context.loaderOverlay.show(progress: "Chuẩn bị tải ");
                          await FileServices().actionDownloadFileWithUrl(
                            context, 
                            url: ConstantString.request12DocumentUrl
                          ).then((value) {
                            context.loaderOverlay.hide();
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
              ),
            ),
            SendRequestButton(
              onPressed: () async {
                isFileAdded = files.isEmpty ? false : true;
                isFormValid() ? await sendFormData() : null;
              }, 
            )
          ],
        )
      ),
    );
  }
}