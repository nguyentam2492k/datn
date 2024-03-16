import 'dart:convert';

import 'package:datn/constants/constant_string.dart';
import 'package:datn/constants/my_icons.dart';
import 'package:datn/global_variable/globals.dart';
import 'package:datn/widgets/custom_widgets/custom_row/text_row.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:datn/constants/constant_list.dart';
import 'package:datn/model/address/province.dart';
import 'package:datn/widgets/custom_widgets/custom_date_picker.dart';
import 'package:datn/widgets/custom_widgets/custom_dropdown_button.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_address_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_textfield_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_row/custom_upload_file_row_widget.dart';
import 'package:datn/widgets/custom_widgets/custom_text_form_field.dart';

class Request18 extends StatefulWidget {
  const Request18({super.key});

  @override
  State<StatefulWidget> createState() {
    return Request18State();
  }
}

class Request18State extends State<Request18> {

  // final GlobalKey<FormBuilderState> _request18FormKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _personalInformationFormKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _familyInformationFormKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _otherInformationFormKey = GlobalKey<FormBuilderState>();
  
  Map<String, dynamic> formData = {};

  late List<PlatformFile> files;
  late bool isFileAdded;

  ValueNotifier<List<PlatformFile>> filesChanged = ValueNotifier([]);

  List<Province> provinces = [];

  Future<List<Province>> getAddressData() async {
    var response = await rootBundle.loadString('assets/data/dvhcvn.json');
    var jsonData = jsonDecode(response)['data'] as List;
    provinces = jsonData.map((provinceJson) => Province.fromJson(provinceJson)).toList();
    return provinces;
  }

  bool isFormValid() {
    return _personalInformationFormKey.currentState!.saveAndValidate() 
          && _familyInformationFormKey.currentState!.saveAndValidate()
          && _otherInformationFormKey.currentState!.saveAndValidate();
  }

  void sendFormData() {
    // formData.addAll(_request18FormKey.currentState!.value);
      
    // List<File> listFiles = files.map((file) => File(file.path!)).toList();
    List<String> listFiles = files.map((file) => file.name).toList();
    formData['file'] = listFiles;
    print("Personal Information: ${_personalInformationFormKey.currentState?.value}");
    print("Family Information: ${_familyInformationFormKey.currentState?.value}");
    print("Other Information: ${_otherInformationFormKey.currentState?.value}");
    print("FILES: ${formData.toString()}");
  }

  @override
  void initState() {
    super.initState();
    files = [];
    isFileAdded = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: getAddressData(),
      builder:(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
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
                          fontSize: 18
                        ),
                      ),
                      const SizedBox(height: 10,),
                      studentInformation(),
                      const Divider(thickness: 0.5,),
                      FormBuilder(
                        key: _personalInformationFormKey,
                        child: ExpansionTile(
                          shape: const Border(),
                          tilePadding: EdgeInsetsDirectional.zero,
                          initiallyExpanded: true,
                          title: const Text(
                            "Thông tin cá nhân",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          children: [
                            personalAddressWidget(),
                            const SizedBox(height: 20,),
                            personalIdentifyCardWidget(),
                            const SizedBox(height: 20,),
                            personalContactWidget(),
                            const SizedBox(height: 20,),
                            personalOtherInformation(),
                            const SizedBox(height: 20,),
                            admissionCodeInformation(),
                            const SizedBox(height: 20,),
                            admissionDateInformation(),
                            const SizedBox(height: 20,),
                            healthInsuranceWidget(),
                            const SizedBox(height: 5,)
                          ]
                        ),
                      ),
                      const Divider(thickness: 0.5,),
                      FormBuilder(
                        key: _familyInformationFormKey,
                        child: ExpansionTile(
                          shape: const Border(),
                          tilePadding: EdgeInsetsDirectional.zero,
                          initiallyExpanded: true,
                          title: const Text(
                            "Thông tin gia đình",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          children: [
                            const SizedBox(height: 10,),
                            householdInformation(),
                            const Divider(thickness: 0.5,),
                            fatherInformation(),
                            const Divider(thickness: 0.5,),
                            motherInformation(),
                            const Divider(thickness: 0.5,),
                            mailingAddressInformation(),
                            const SizedBox(height: 5,)
                          ],
                        ),
                      ),
                      const Divider(thickness: 0.5,),
                      FormBuilder(
                        key: _otherInformationFormKey,
                        child: ExpansionTile(
                          shape: const Border(),
                          tilePadding: EdgeInsetsDirectional.zero,
                          initiallyExpanded: true,
                          title: const Text(
                            "Thông tin khác",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          children: [
                            familyTypeInformation(),
                            const SizedBox(height: 15,),
                            feeInformation(),
                            const SizedBox(height: 15,),
                          ],
                        ),
                      ),
                      const Divider(thickness: 0.5,),
                      uploadFile(),
                    ],
                  )
                ),
              ),
              SendRequestButton(
                icon: const Icon(MyIcons.save),
                labelText: "Lưu hồ sơ",
                onPressed: () {
                  isFileAdded = files.isEmpty ? false : true;
                  isFormValid() ? sendFormData() : null;
                }, 
              )
            ],
          );
        } 
        else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  BoxConstraints shortConstraints = const BoxConstraints(maxWidth: 150, maxHeight: 45);
  BoxConstraints mediumConstraints = const BoxConstraints(maxWidth: 230, maxHeight: 45);
  TextStyle customTextStyle = const TextStyle(
    fontSize: 13,
    color: Colors.black,
  );

  InputDecoration customDecoration({String? labelText, String? hintText, bool? isDatePicker}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        fontSize: 13,
        color: Colors.grey,
        fontWeight: FontWeight.normal,
      ),
      hintMaxLines: 1,
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: 13,
        color: Colors.grey,
        fontWeight: FontWeight.normal
      ),
      errorStyle: const TextStyle(
        fontSize: 10,
        height: 0.3
      ),
      suffixIcon: isDatePicker ?? false ? const Icon(MyIcons.calendar, size: 17,) : null,
      suffixIconColor: Colors.grey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          width: 0.5,
          color: Colors.grey,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  Widget studentInformation() {
    return Row(
      children: [
        Container(
          width: 100,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1)
          ),
          child: Image.network(
             globalLoginResponse!.user?.image ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(MyIcons.noImage, size: 30, color: Colors.grey,)
              );
            },
          ),
        ),
        const Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextRow(
                labelText: "Họ và tên:",
                text: "Nguyễn Văn A",
              ),
              CustomTextRow(
                labelText: "Mã sinh viên:",
                text: "12345678",
              ),
              CustomTextRow(
                labelText: "Ngày sinh:",
                text: "10/10/2020",
              ),
              CustomTextRow(
                labelText: "Giới tính:",
                text: "Nam",
              ),
              CustomTextRow(
                labelText: "Khoá:",
                text: "QH-2023-I/CQ",
              ),
            ],
          )
        )
      ],
    );
  }

  Widget personalAddressWidget() {
    return Column(
      children: [
        const SizedBox(height: 10,),
        CustomAddressRowWidget(
          formKey: _personalInformationFormKey,
          labelText: "Nơi khai sinh:",
          provinceName: 'tinh_khaisinh', 
          districtName: 'huyen_khaisinh', 
          wardName: 'xa_khaisinh',
          provinces: provinces,
        ),
        const SizedBox(height: 15,),
        CustomAddressRowWidget(
          formKey: _personalInformationFormKey,
          labelText: "Hộ khẩu thường chú:", 
          provinceName: 'tinh_thuongtru', 
          districtName: 'huyen_thuongtru', 
          wardName: 'xa_thuongtru',
          provinces: provinces, 
        )
      ],
    );
  }

  Widget personalIdentifyCardWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "CMND/CCCD:",
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
          flex: 4,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                constraints: mediumConstraints,
                child: CustomFormBuilderTextField(
                  name: 'identify_id',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty ) {
                      return "Điền đầy đủ thông tin!";
                    }
                    return null;
                  },
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Số CMND/CCCD *"),
                ),
              ),
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDateTimePicker(
                  name: 'identify_date',
                  validator: (value) {
                    if (value == null) {
                      return "Chọn ngày chính xác";
                    }
                    return null;
                  },
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Ngày cấp *", isDatePicker: true),
                ),
              ),
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDropdown(
                  name: 'identify_address',
                  items: provinces
                    .map((province) => DropdownMenuItem(
                      value: province.name, 
                      child: Text(
                        province.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                    .toList(),
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Tỉnh/Tp"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget personalContactWidget() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Thông tin liên hệ:",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 4,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderTextField(
                  name: 'phone_contact',
                  keyboardType: TextInputType.phone,
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Số điện thoại"),
                ),
              ),
              Container(
                constraints: mediumConstraints,
                child: CustomFormBuilderTextField(
                  name: 'email_contact',
                  keyboardType: TextInputType.emailAddress,
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Email"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget personalOtherInformation() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Khác:",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 4,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDropdown(
                  name: 'ethnicity',
                  items: ConstantList.ethnics
                    .map((ethnic) => DropdownMenuItem(
                      value: ethnic, 
                      child: Text(
                        ethnic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                    .toList(),
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Dân tộc"),
                ),
              ),
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDropdown(
                  name: 'religion',
                  items: ConstantList.religions
                    .map((religion) => DropdownMenuItem(
                      value: religion, 
                      child: Text(
                        religion,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                    .toList(),
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Tôn giáo"),
                ),
              ),
            ],
          ),
        ),
      ]
    );
  }

  Widget admissionCodeInformation() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Mã xét tuyển:",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 4,
          child: Container(
            constraints: shortConstraints,
            child: CustomFormBuilderDropdown(
              name: 'admission_code',
              items: ConstantList.admissionCodes
                .map((admissionCode) => DropdownMenuItem(
                  value: admissionCode, 
                  child: Text(
                    admissionCode,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
                .toList(),
              style: customTextStyle,
              decoration: customDecoration(hintText: "Chọn mã xét tuyển"),
            ),
          ),
        ),
      ]
    );
  }

  Widget admissionDateInformation() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Ngày nhập trường:",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 2,
          child: Container(
            constraints: shortConstraints,
            child: CustomFormBuilderDateTimePicker(
              name: 'admission_date',
              style: customTextStyle,
              decoration: customDecoration(hintText: "Chọn ngày", isDatePicker: true),
            ),
          ),
        ),
        const Expanded(flex: 2, child: SizedBox())
      ]
    );
  }

  Widget healthInsuranceWidget() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Mã bảo hiểm y tế:",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 4,
          child: Tooltip(
            message: "Nhập đủ cả phần chữ và phần số",
            child: CustomFormBuilderTextField(
              name: 'health_insurance_id',
              style: customTextStyle,
              decoration: customDecoration(labelText: "Mã bảo hiểm y tế"),
            ),
          ),
        )
      ]
    );
  }

  Widget householdInformation() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Thông tin chủ hộ:",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormBuilderTextField(
                name: 'household_name',
                keyboardType: TextInputType.name,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Họ và tên"),
              ),
              const SizedBox(height: 10,),
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDateTimePicker(
                  name: 'household_birthdate',
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Ngày sinh", isDatePicker: true),
                ),
              ),
              const SizedBox(height: 5,),
              FormBuilderChoiceChip(
                name: "household_gender", 
                spacing: 5,
                shape: const StadiumBorder(side: BorderSide(color: Colors.grey, width: 0.5)),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  prefixIcon:Text(
                    "Giới tính:  ",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF3F3F3F),
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                ),
                backgroundColor: Colors.transparent,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                options: ConstantList.genders
                  .map((gender) => FormBuilderChipOption(
                      value: gender,
                      child: SizedBox(
                        width: 50,
                        child: Center(
                          child: Text(
                            gender,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF3F3F3F),
                            ),
                          )
                        ),
                      ),
                    ))
                  .toList()
              ),
              const SizedBox(height: 5,),
              CustomFormBuilderTextField(
                name: 'relative_with_household',
                keyboardType: TextInputType.name,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Quan hệ Sinh viên-Chủ hộ"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget fatherInformation() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Thông tin của Bố:",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormBuilderTextField(
                name: 'father_name',
                keyboardType: TextInputType.name,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Họ và tên"),
              ),
              const SizedBox(height: 10,),
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDateTimePicker(
                  name: 'father_birthdate',
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Ngày sinh", isDatePicker: true),
                ),
              ),
              const SizedBox(height: 10,),
              CustomFormBuilderTextField(
                name: 'father_phone',
                keyboardType: TextInputType.phone,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Số điện thoại"),
              ),
              const SizedBox(height: 10,),
              CustomFormBuilderTextField(
                name: 'father_job',
                style: customTextStyle,
                decoration: customDecoration(labelText: "Nghề nghiệp"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget motherInformation() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Thông tin của Mẹ:",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormBuilderTextField(
                name: 'mother_name',
                keyboardType: TextInputType.name,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Họ và tên"),
              ),
              const SizedBox(height: 10,),
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDateTimePicker(
                  name: 'mother_birthdate',
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Ngày sinh", isDatePicker: true),
                ),
              ),
              const SizedBox(height: 10,),
              CustomFormBuilderTextField(
                name: 'mother_phone',
                keyboardType: TextInputType.phone,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Số điện thoại"),
              ),
              const SizedBox(height: 10,),
              CustomFormBuilderTextField(
                name: 'mother_job',
                style: customTextStyle,
                decoration: customDecoration(labelText: "Nghề nghiệp"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget mailingAddressInformation() {
    return const Tooltip(
      message: "Ghi rõ số nhà, tổ dân phố/thôn/xóm, xã/phường, quận/huyện, tỉnh/TP",
      child: CustomTextFieldRowWidget(
        name: "mailing_address",
        labelText: "Địa chỉ nhận thư của gia đình:", 
        maxLines: 3,
        isImportant: false,
      ),
    );
  }

  Widget familyTypeInformation() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Thuộc diện:",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 4,
          child: FormBuilderCheckboxGroup(
            name: 'student_types', 
            decoration: const InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
            ),
            options: ConstantList.studentTypes
              .map((type) => FormBuilderFieldOption(
                value: type,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 150),
                  child: Text(type)
                ),
              ))
              .toList(),
          ),
        ),
      ]
    ); 
  }

  Widget feeInformation() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: Text(
            "Học phí (miễn/giảm):",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 4,
          child: FormBuilderRadioGroup(
            name: 'fee_types', 
            decoration: const InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
            ),
            options: ConstantList.feeTypes
              .map((type) => FormBuilderFieldOption(
                value: type,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 150),
                  child: Text(type)
                ),
              ))
              .toList(),
          ),
        ),
      ]
    ); 
  }

  Widget uploadFile() {
    return ValueListenableBuilder(
      valueListenable: filesChanged,
      builder: (context, myFiles, child) {
        return CustomUploadFileRowWidget(
          labelText: "Cập nhật Ảnh thẻ(01 ảnh, jpg, 4x6):",
          isImportant: false,
          allowMultiple: false,
          isPickImage: true,
          files: myFiles,
          isFileAdded: isFileAdded,
          onChanged: (value) {
            filesChanged.value = List.from(value);
            files = filesChanged.value;
          }, 
        );
      },
    );
  }

}