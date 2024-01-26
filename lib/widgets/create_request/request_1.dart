// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:datn/widgets/custom_widgets/bottom_sheet_with_list.dart';
import 'package:datn/widgets/custom_widgets/numeric_step_button.dart';

class Request1Data {
  String certificatation;
  int vietnameseVersion;
  int englishVersion;
  String reason;

  Request1Data({
    required this.certificatation,
    required this.vietnameseVersion,
    required this.englishVersion,
    required this.reason,
  });

  Map<String, dynamic> toMap(){
    return {
      'certificatation': certificatation,
      'vietnameseVersion': vietnameseVersion,
      'englishVersion': englishVersion,
      'reason': reason,
    };
  }
}

class Request1 extends StatefulWidget {
  const Request1({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request1Stated();
  }
}

class Request1Stated extends State<Request1> {
  final _formKey = GlobalKey<FormState>();

  late final Request1Data formData;

  List<String> certificationList = [
    "Chứng nhận Sinh viên /HV/NCS", 
    "Sinh viên nhiệm vụ chiến lược", 
    "Học bổng (Điền chi tiết tên học bổng, năm nhận vào ô Lý do bên dưới)", 
    "Mất thẻ sinh viên (Dùng để tham gia các hoạt động và học tập trong trường)", 
    "Kê khai thuế thu nhập", 
    "Hoãn nghĩa vụ quân sự", 
    "Đăng ký ở KTX", 
    "Xin Visa", 
    "Chưa hoàn thành khóa học (Dùng để tham gia các hoạt động và học tập tại trường)", 
    "Giấy giới thiệu thực tập (Giấy giới thiệu thực tập)", 
    "Loại khác (Điền chi tiết yêu cầu giấy chứng nhận vào ô Lý do bên dưới)", 
    ];
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

  @override
  void initState() {
    super.initState();
    selectedCertification = null;
    formData = Request1Data(
      certificatation: '', 
      vietnameseVersion: 1, 
      englishVersion: 0, 
      reason: '',
    );
    numberOfVietVer = 1;
    numberOfEngVer= 0;
  }

  @override
  Widget build(BuildContext context) {

    void sendFormData() {
      formData.vietnameseVersion = numberOfVietVer!;
      formData.englishVersion = numberOfEngVer!;
      debugPrint("Yeu cau: ${formData.toMap().toString()}");
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Loại giấy chứng nhận:",
                            style: TextStyle(
                     
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
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
                                  formData.certificatation = data;
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
                    height: MediaQuery.of(context).size.height * 0.25,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          child: TextFormField(
                            maxLines: 100,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 0.3,
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty ) {
                                return "Điền đầy đủ thông tin!";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              formData.reason = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
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
                onPressed: () {
                  (isFormValid() && _formKey.currentState!.validate()) ? sendFormData() : null;
                }, 
                label: const Text("Gửi yêu cầu"),
              ),
            ),
          )
        ],
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
          list: certificationList,
          selectedItem: selectedItemChanged,
        );
      },
    );
  }
}