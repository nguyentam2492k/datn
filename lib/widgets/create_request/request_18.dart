import 'package:datn/constants/constant_string.dart';
import 'package:datn/services/file/file_services.dart';
import 'package:datn/widgets/custom_widgets/custom_date_range_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:datn/widgets/custom_widgets/loading_hud.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Request18 extends StatefulWidget {
  const Request18({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request18State();
  }
}

class Request18State extends State<Request18> {

  final GlobalKey<FormBuilderState> _request18FormKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> formData = {};

  List<PlatformFile> files = [];

  bool isFileAdded = true;

  bool isFormValid() {
    if (_request18FormKey.currentState!.saveAndValidate() && files.isNotEmpty) {
      return true;
    }
    return false;
  }

  void sendFormData() {
    formData.addAll(_request18FormKey.currentState!.value);
      
    // List<File> listFiles = files.map((file) => File(file.path!)).toList();
    List<String> listFiles = files.map((file) => file.name).toList();
    formData['file'] = listFiles;
    print(formData.toString());
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
        key: _request18FormKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      ConstantString.request18Note,
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
                          print(ConstantString.request18DocumentUrl);
                          context.loaderOverlay.show(progress: "Đang tải xuống");
                          await FileServices().downloadFileFromUrl(
                            context, 
                            url: ConstantString.request18DocumentUrl
                          ).then((value) {
                            context.loaderOverlay.hide();
                          });
                        },
                      ),
                    ),
                    const Divider(thickness: 0.4,),
                    const Text(
                      "Đề nghị được thuê phòng Khu nhà ở sinh viên Mỹ Đình II "
                      "(đính kèm tệp minh chứng nếu thuộc diện ưu tiên):",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    CustomTextFieldRowWidget(
                      labelText: "Đơn nguyên đề nghị:", 
                      name: "name", 
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
                                  text: "Thời gian thuê:",
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
                          flex: 3,
                          child: CustomFormBuilderDateRangePicker(
                            name: 'date_range',
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                            initialValue: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                            validator: (value) => (value == null) ? "Chọn thời gian chính xác" : null,
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    const Divider(thickness: 0.4,),
                    const Text(
                      "Thông tin cá nhân",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const CustomTextFieldRowWidget(
                      labelText: "Đối tượng ưu tiên:", 
                      name: "doituonguutien", 
                      isImportant: false,
                    ),
                    const SizedBox(height: 10,),
                    const CustomTextFieldRowWidget(
                      labelText: "Địa chỉ thường trú:", 
                      name: "address", 
                      isImportant: false,
                    ),
                    const SizedBox(height: 10,),
                    const CustomTextFieldRowWidget(
                      labelText: "Điện thoại liên hệ:", 
                      name: "phone_contact", 
                      isImportant: false,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10,),
                    const CustomTextFieldRowWidget(
                      labelText: "Email:", 
                      name: "email", 
                      isImportant: false,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10,),
                    const CustomTextFieldRowWidget(
                      labelText: "Khi cần liên hệ (báo tin cho):", 
                      name: "khicanbaotin", 
                      isImportant: false,
                    ),
                    const SizedBox(height: 5,),
                    const Divider(thickness: 0.4,),
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
                  onPressed: () {
                    isFileAdded = files.isEmpty ? false : true;
                    isFormValid() ? sendFormData() : null;
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