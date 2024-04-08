import 'package:datn/function/function.dart';

class StudentProfile {
  String? name;
  String? id;
  String? image;
  String? birthdate;
  String? gender;
  String? schoolCourse;
  String? tinhKhaisinh;
  String? huyenKhaisinh;
  String? xaKhaisinh;
  String? tinhThuongtru;
  String? huyenThuongtru;
  String? xaThuongtru;
  String? identifyId;
  String? identifyDate;
  String? identifyAddress;
  String? phoneContact;
  String? emailContact;
  String? ethnicity;
  String? religion;
  String? admissionCode; //Ma xet tuyen
  String? admissionDate;
  String? healthInsuranceId; //Ma bao hiem y te
  String? householdName; 
  String? householdBirthdate; 
  String? householdGender; 
  String? relativeWithHousehold; 
  String? fatherName; 
  String? fatherBirthdate; 
  String? fatherPhone; 
  String? fatherJob; 
  String? motherName; 
  String? motherBirthdate; 
  String? motherPhone; 
  String? motherJob; 
  String? mailingAddress;
  List<String>? studentTypes;
  String? feeTypes;

  StudentProfile({
    required this.name,
    required this.id,
    this.image,
    required this.birthdate,
    required this.gender,
    required this.schoolCourse,
    this.tinhKhaisinh,
    this.huyenKhaisinh,
    this.xaKhaisinh,
    this.tinhThuongtru,
    this.huyenThuongtru,
    this.xaThuongtru,
    this.identifyId,
    this.identifyDate,
    this.identifyAddress,
    this.phoneContact,
    this.emailContact,
    this.ethnicity,
    this.religion,
    this.admissionCode,
    this.admissionDate,
    this.healthInsuranceId,
    this.householdName,
    this.householdBirthdate,
    this.householdGender,
    this.relativeWithHousehold,
    this.fatherName,
    this.fatherBirthdate,
    this.fatherPhone,
    this.fatherJob,
    this.motherName,
    this.motherBirthdate,
    this.motherPhone,
    this.motherJob,
    this.mailingAddress,
    this.studentTypes,
    this.feeTypes,
  });
  
  factory StudentProfile.fromJson(Map<String, dynamic> map) {
    return StudentProfile(
      name: map['name'] as String?,
      id: map['id'] as String?,
      image: map['image'] as String?,
      birthdate: map['birthdate'] as String?,
      gender: map['gender'] as String?,
      schoolCourse: map['school_course'] as String?,
      tinhKhaisinh: map['tinh_khaisinh'] != null ? map['tinh_khaisinh'] as String : null,
      huyenKhaisinh: map['huyen_khaisinh'] != null ? map['huyen_khaisinh'] as String : null,
      xaKhaisinh: map['xa_khaisinh'] != null ? map['xa_khaisinh'] as String : null,
      tinhThuongtru: map['tinh_thuongtru'] != null ? map['tinh_thuongtru'] as String : null,
      huyenThuongtru: map['huyen_thuongtru'] != null ? map['huyen_thuongtru'] as String : null,
      xaThuongtru: map['xa_thuongtru'] != null ? map['xa_thuongtru'] as String : null,
      identifyId: map['identify_id'] != null ? map['identify_id'] as String : null,
      identifyDate: map['identify_date'] != null ? map['identify_date'] as String : null,
      identifyAddress: map['identify_address'] != null ? map['identify_address'] as String : null,
      phoneContact: map['phone_contact'] != null ? map['phone_contact'] as String : null,
      emailContact: map['email_contact'] != null ? map['email_contact'] as String : null,
      ethnicity: map['ethnicity'] != null ? map['ethnicity'] as String : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      admissionCode: map['admission_code'] != null ? map['admission_code'] as String : null,
      admissionDate: map['admission_date'] != null ? map['admission_date'] as String : null,
      healthInsuranceId: map['health_insurance_id'] != null ? map['health_insurance_id'] as String : null,
      householdName: map['household_name'] != null ? map['household_name'] as String : null,
      householdBirthdate: map['household_birthdate'] != null ? map['household_birthdate'] as String : null,
      householdGender: map['household_gender'] != null ? map['household_gender'] as String : null,
      relativeWithHousehold: map['relative_with_household'] != null ? map['relative_with_household'] as String : null,
      fatherName: map['father_name'] != null ? map['father_name'] as String : null,
      fatherBirthdate: map['father_birthdate'] != null ? map['father_birthdate'] as String : null,
      fatherPhone: map['father_phone'] != null ? map['father_phone'] as String : null,
      fatherJob: map['father_job'] != null ? map['father_job'] as String : null,
      motherName: map['mother_name'] != null ? map['mother_name'] as String : null,
      motherBirthdate: map['mother_birthdate'] != null ? map['mother_birthdate'] as String : null,
      motherPhone: map['mother_phone'] != null ? map['mother_phone'] as String : null,
      motherJob: map['mother_job'] != null ? map['mother_job'] as String : null,
      mailingAddress: map['mailing_address'] != null ? map['mailing_address'] as String : null,
      studentTypes: map['student_types'] != null ? toListString(map["student_types"]) : null,
      feeTypes: map['fee_types'] != null ? map['fee_types'] as String : null,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'name': name,
  //     'id': id,
  //     'image': image,
  //     'birthdate': birthdate,
  //     'gender': gender,
  //     'school_course': schoolCourse,
  //     'tinh_khaisinh': tinhKhaisinh,
  //     'huyen_khaisinh': huyenKhaisinh,
  //     'xa_khaisinh': xaKhaisinh,
  //     'tinh_thuongtru': tinhThuongtru,
  //     'huyen_thuongtru': huyenThuongtru,
  //     'xa_thuongtru': xaThuongtru,
  //     'identify_id': identifyId,
  //     'identify_date': identifyDate,
  //     'identify_address': identifyAddress,
  //     'phone_contact': phoneContact,
  //     'email_contact': emailContact,
  //     'ethnicity': ethnicity,
  //     'religion': religion,
  //     'admission_code': admissionCode,
  //     'admission_date': admissionDate,
  //     'health_insurance_id': healthInsuranceId,
  //     'household_name': householdName,
  //     'household_dirthdate': householdBirthdate,
  //     'household_gender': householdGender,
  //     'relative_with_household': relativeWithHousehold,
  //     'father_name': fatherName,
  //     'father_birthdate': fatherBirthdate,
  //     'father_phone': fatherPhone,
  //     'father_job': fatherJob,
  //     'mother_name': motherName,
  //     'mother_birthdate': motherBirthdate,
  //     'mother_phone': motherPhone,
  //     'mother_job': motherJob,
  //     'mailing_address': mailingAddress,
  //     'student_types': studentTypes,
  //     'fee_types': feeTypes,
  //   };
  // }

}
