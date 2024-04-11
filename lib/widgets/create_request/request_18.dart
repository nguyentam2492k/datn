import 'dart:convert';

import 'package:datn/constants/constant_string.dart';
import 'package:datn/constants/my_icons.dart';
import 'package:datn/function/function.dart';
import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/address/address.dart';
import 'package:datn/model/student/student_profile.dart';
import 'package:datn/services/api/api_service.dart';
import 'package:datn/widgets/custom_widgets/custom_row/text_row.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:datn/widgets/custom_widgets/send_request_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  final GlobalKey<FormBuilderState> _personalInformationFormKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _familyInformationFormKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _otherInformationFormKey = GlobalKey<FormBuilderState>();
  
  APIService apiService = APIService();
  late StudentProfile studentProfile;
  
  Map<String, dynamic> formData = {};

  PlatformFile? file;

  ValueNotifier<List<PlatformFile>> filesChanged = ValueNotifier([]);

  List<Province> provinces = [];

  Future<List<Province>> getAddressData() async {
    var response = await rootBundle.loadString('assets/data/dvhcvn.json');
    var jsonData = jsonDecode(response)['data'] as List;
    provinces = jsonData.map((provinceJson) => Province.fromJson(provinceJson)).toList();
    return provinces;
  }

  Future<void> getStudentInformation() async {
    try {
      await apiService.getStudentInformation().then((value) {
        studentProfile = value;
      });
    } catch (e) {
      MyToast.showToast(
        isError: true,
        errorText: e.toString()
      );
    }
  }

  bool isFormValid() {
    return _personalInformationFormKey.currentState!.saveAndValidate() 
          && _familyInformationFormKey.currentState!.saveAndValidate()
          && _otherInformationFormKey.currentState!.saveAndValidate();
  }

  Future<void> sendFormData() async {
      
    formData.addAll(_personalInformationFormKey.currentState!.value);
    formData.addAll(_familyInformationFormKey.currentState!.value);
    formData.addAll(_otherInformationFormKey.currentState!.value);

    await EasyLoading.show(status: "Đang lưu");

    try {
      await apiService.updateStudentProfile(profile: formData, image: file).then((value) async {
        setGlobalLoginResponse(value);
        secureStorageServices.writeSaveUserInfo(studentProfile: value);
        
        await EasyLoading.dismiss();
        MyToast.showToast(
          text: "Lưu thành công"
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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Future.wait([getStudentInformation(), getAddressData()]),
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
                        initialValue: {
                          'identity_date': getDateFromString(studentProfile.identityDate),
                          'admission_date': getDateFromString(studentProfile.admissionDate)
                        },
                        child: ExpansionTile(
                          shape: const Border(),
                          tilePadding: EdgeInsetsDirectional.zero,
                          initiallyExpanded: true,
                          maintainState: true,
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
                        initialValue: {
                          'householder_dob': getDateFromString(studentProfile.householdBirthdate),
                          'father_dob': getDateFromString(studentProfile.fatherBirthdate),
                          'mother_dob': getDateFromString(studentProfile.motherBirthdate),
                        },
                        child: ExpansionTile(
                          shape: const Border(),
                          tilePadding: EdgeInsetsDirectional.zero,
                          initiallyExpanded: true,
                          maintainState: true,
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
                          maintainState: true,
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
                onPressed: () async {
                  isFormValid() ? await sendFormData().then((value) => setState(() {})) : null;
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
             studentProfile.image ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
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
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextRow(
                labelText: "Họ và tên:",
                text: studentProfile.name ?? "NAME",
              ),
              CustomTextRow(
                labelText: "Mã sinh viên:",
                text: studentProfile.id ?? "MSV",
              ),
              CustomTextRow(
                labelText: "Ngày sinh:",
                text: formatDateWithTime(studentProfile.birthdate) ?? "00/00/0000",
              ),
              CustomTextRow(
                labelText: "Giới tính:",
                text: studentProfile.gender ?? "GENDER",
              ),
              CustomTextRow(
                labelText: "Khoá:",
                text: studentProfile.schoolCourse ?? "KHOÁ",
              ),
            ],
          )
        )
      ],
    );
  }

  Widget personalAddressWidget() {
    var initAddress = Address(
      province: studentProfile.tinhKhaisinh,
      district: studentProfile.huyenKhaisinh,
      ward: studentProfile.xaKhaisinh
    );

    return Column(
      children: [
        const SizedBox(height: 10,),
        CustomAddressRowWidget(
          formKey: _personalInformationFormKey,
          labelText: "Nơi khai sinh:",
          provinceName: 'birth_city', 
          districtName: 'birth_district', 
          wardName: 'birth_ward',
          provinces: provinces,
          initialAddress: initAddress,
        ),
        const SizedBox(height: 15,),
        CustomAddressRowWidget(
          formKey: _personalInformationFormKey,
          labelText: "Hộ khẩu thường trú:", 
          provinceName: 'residence_city', 
          districtName: 'residence_district', 
          wardName: 'residence_ward',
          provinces: provinces,
          initialAddress: Address(
            province: studentProfile.tinhThuongtru,
            district: studentProfile.huyenThuongtru,
            ward: studentProfile.xaThuongtru
          ),
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
                  name: 'identity_number',
                  initialValue: studentProfile.identityId,
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
                  name: 'identity_date',
                  inputType: InputType.date,
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
                  name: 'identity_place',
                  initialValue: studentProfile.identityAddress,
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
                  name: 'phone_number',
                  initialValue: studentProfile.phoneContact,
                  keyboardType: TextInputType.phone,
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Số điện thoại"),
                ),
              ),
              Container(
                constraints: mediumConstraints,
                child: CustomFormBuilderTextField(
                  name: 'email',
                  initialValue: studentProfile.emailContact,
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
                  name: 'ethnic',
                  initialValue: studentProfile.ethnicity,
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
                  valueTransformer: (value) {
                    final ethnicIndex = ConstantList.ethnics.indexOf(value!) + 1;
                    return ethnicIndex;
                  },
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Dân tộc"),
                ),
              ),
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDropdown(
                  name: 'religion',
                  initialValue: studentProfile.religion,
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
                  valueTransformer: (value) {
                    final religionIndex = ConstantList.religions.indexOf(value!) + 1;
                    return religionIndex;
                  },
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
              initialValue: studentProfile.admissionCode,
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
              valueTransformer: (value) {
                final admissionCodeIndex = ConstantList.admissionCodes.indexOf(value!) + 1;
                return admissionCodeIndex;
              },
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
              name: 'health_insurance_code',
              initialValue: studentProfile.healthInsuranceId,
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
                name: 'householder_name',
                initialValue: studentProfile.householdName,
                keyboardType: TextInputType.name,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Họ và tên"),
              ),
              const SizedBox(height: 10,),
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDateTimePicker(
                  name: 'householder_dob',
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Ngày sinh", isDatePicker: true),
                ),
              ),
              const SizedBox(height: 5,),
              FormBuilderChoiceChip(
                name: "householder_gender", 
                initialValue: studentProfile.householdGender,
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
                  .toList(),
                valueTransformer: (value) {
                  final genderIndex = ConstantList.genders.indexOf(value!) + 1;
                  return genderIndex;
                },                
              ),
              const SizedBox(height: 5,),
              CustomFormBuilderTextField(
                name: 'householder_relationship',
                initialValue: studentProfile.relativeWithHousehold,
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
                initialValue: studentProfile.fatherName,
                keyboardType: TextInputType.name,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Họ và tên"),
              ),
              const SizedBox(height: 10,),
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDateTimePicker(
                  name: 'father_dob',
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Ngày sinh", isDatePicker: true),
                ),
              ),
              const SizedBox(height: 10,),
              CustomFormBuilderTextField(
                name: 'father_phone_number',
                initialValue: studentProfile.fatherPhone,
                keyboardType: TextInputType.phone,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Số điện thoại"),
              ),
              const SizedBox(height: 10,),
              CustomFormBuilderTextField(
                name: 'father_job',
                initialValue: studentProfile.fatherJob,
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
                initialValue: studentProfile.motherName,
                keyboardType: TextInputType.name,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Họ và tên"),
              ),
              const SizedBox(height: 10,),
              Container(
                constraints: shortConstraints,
                child: CustomFormBuilderDateTimePicker(
                  name: 'mother_dob',
                  style: customTextStyle,
                  decoration: customDecoration(labelText: "Ngày sinh", isDatePicker: true),
                ),
              ),
              const SizedBox(height: 10,),
              CustomFormBuilderTextField(
                name: 'mother_phone_number',
                initialValue: studentProfile.motherPhone,
                keyboardType: TextInputType.phone,
                style: customTextStyle,
                decoration: customDecoration(labelText: "Số điện thoại"),
              ),
              const SizedBox(height: 10,),
              CustomFormBuilderTextField(
                name: 'mother_job',
                initialValue: studentProfile.motherJob,
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
    return Tooltip(
      message: "Ghi rõ số nhà, tổ dân phố/thôn/xóm, xã/phường, quận/huyện, tỉnh/TP",
      child: CustomTextFieldRowWidget(
        name: "mailing_address",
        initialValue: studentProfile.mailingAddress,
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
            initialValue: studentProfile.studentTypes,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              isDense: true
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
            valueTransformer: (value) {
              if (value != null) {
                final valueIndex = value.map((e) => ConstantList.studentTypes.indexOf(e) + 1).toList();
                valueIndex.sort();
                return valueIndex;
              } 
            },
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
            name: 'tuition_fee_type', 
            initialValue: studentProfile.feeTypes,
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
            valueTransformer: (value) {
              final feeTypeIndex = ConstantList.feeTypes.indexOf(value!) + 1;
              return feeTypeIndex;
            },
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
          isFileAdded: true,
          onChanged: (value) {
            filesChanged.value = List.from(value);
            file = filesChanged.value[0];
          }, 
        );
      },
    );
  }

}