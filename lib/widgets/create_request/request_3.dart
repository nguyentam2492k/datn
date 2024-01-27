import 'dart:io';
import 'package:datn/widgets/custom_widgets/custom_date_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_text_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:open_file/open_file.dart';

class Request3 extends StatefulWidget {
  const Request3({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return Request3State();
  }

}

class Request3State extends State<Request3> {

  final GlobalKey<FormBuilderState> _request3FormKey = GlobalKey<FormBuilderState>();

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

    void sendFormData() {
      formData.addAll(_request3FormKey.currentState!.value);
      
      List<File> listFiles = files.map((file) => File(file.path!)).toList();
      formData['file'] = listFiles;
      debugPrint(formData.toString());
    }

    return FormBuilder(
      key: _request3FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    "Sinh viên điền đầy đủ thông tin bên dưới, "
                    "đính kèm bản scan giấy xác nhận các lý do "
                    "đã nêu trong phần lý do (giấy khám bệnh…), "
                    "sau đó bấm Gửi yêu cầu để nộp bàn gốc cho "
                    "phòng 104-E3 trong vòng 05 ngày kể từ ngày thi.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(thickness: 0.4,),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Môn học:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: CustomFormBuilderTextField(
                          name: 'subject',
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
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Giảng viên giảng dạy:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: CustomFormBuilderTextField(
                          name: 'lecturer',
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
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          "Ngày thi:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Lý do:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: CustomFormBuilderTextField(
                            name: "reason",
                            maxLines: 100,
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Tệp đính kèm:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 45,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      OutlinedButton.icon(
                                        icon: const Icon(Icons.file_upload_outlined),
                                        label: const Text('Thêm tệp'),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            width: 0.5,
                                            color: Colors.grey,
                                          ),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                        ),
                                        onPressed: () async {
                                          try {
                                            FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
                                            
                                            if (result != null) {
                                              files.addAll(result.files);
                                              for (var file in files) {
                                                debugPrint("${file.name}\n${file.size}");
                                              }
                                              debugPrint('Add completed');
                                            } else {
                                              debugPrint("Nothing added");
                                            }
                                            setState(() {});
                                          } catch (error) {
                                            debugPrint(error.toString());
                                          }
                                        },
                                      ),
                                      Visibility(
                                        visible: !isFileAdded,
                                        child: Container(
                                          height: 30,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: const Text(
                                            "Thêm tệp đính kèm",
                                            style: TextStyle(
                                              color: Color(0xFFCF0202),
                                              fontSize: 12
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: GridView.builder(
                                      itemCount: files.length,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, 
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        mainAxisExtent: 30,
                                      ),
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                            border: Border.all(color: Colors.grey),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const SizedBox(width: 2,),
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: TextButton.icon(
                                                    icon: const Icon(Icons.attach_file, size: 14,), 
                                                    label: Text(
                                                      files[index].name,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                    style: OutlinedButton.styleFrom(
                                                      padding: const EdgeInsets.only(left: 3),
                                                      side: const BorderSide(
                                                        color: Colors.transparent,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      OpenResult result;
                                                      try {
                                                        result = await OpenFile.open(
                                                          files[index].path,
                                                        );
                                                        setState(() {
                                                          debugPrint("type=${result.type}  message=${result.message}");
                                                        });
                                                      } catch (error) {
                                                        debugPrint(error.toString());
                                                      }
                                                    }, 
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: IconButton(
                                                    icon: const Icon(Icons.close),
                                                    onPressed: (){
                                                      files.removeAt(index);
                                                      setState(() {});
                                                    }, 
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ),
                              ],
                            )
                          ),
                        ],
                      ),
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
    );
  }
}