import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:datn/widgets/custom_widgets/bottom_sheet_with_list.dart';
import 'package:datn/widgets/custom_widgets/numeric_step_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Request1Data {
  String certificatation;
  int vietnameseVersion;
  int englishVersion;
  String? reason;

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
  
  final GlobalKey<FormBuilderState> _request1FormKey = GlobalKey<FormBuilderState>();

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
  late String? reason;

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
    numberOfVietVer = 1;
    numberOfEngVer= 0;
  }

  @override
  Widget build(BuildContext context) {

    void sendFormData() {
      Request1Data formData = Request1Data(
        certificatation: selectedCertification!, 
        vietnameseVersion: numberOfVietVer!, 
        englishVersion: numberOfEngVer!, 
        reason: reason,
      );

      debugPrint("Yeu cau: ${formData.toMap().toString()}");
    }

    return FormBuilder(
      key: _request1FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  const Text(
                    "Sinh viên kích chọn loại giấy thích hợp theo yêu cầu, "
                    "số bản bằng tiếng Việt hoặc tiếng Anh; Giấy giới thiệu thực "
                    "tập cần ghi rõ tên công ty, thời gian thực tập. "
                    "đến Phòng 104-E3 nhận kết quả sau 01 ngày làm việc.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                      onChanged: (value) {
                        reason = value;
                        setState(() {});
                      },                    
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
                  (isFormValid() && _request1FormKey.currentState!.validate()) ? sendFormData() : null;
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