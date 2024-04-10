class StudentProfile {
  String? name;
  String? id;
  String? email;
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
  String? identityId;
  String? identityDate;
  String? identityAddress;
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
    this.name,
    this.id,
    this.email,
    this.image,
    this.birthdate,
    this.gender,
    this.schoolCourse,
    this.tinhKhaisinh,
    this.huyenKhaisinh,
    this.xaKhaisinh,
    this.tinhThuongtru,
    this.huyenThuongtru,
    this.xaThuongtru,
    this.identityId,
    this.identityDate,
    this.identityAddress,
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
    Map<String, dynamic> profile = map['profile'];

    List<String> listStudentTypesString = [];
    var listStudentTypes = profile["student_types"] as List?;

    if (listStudentTypes != null && listStudentTypes.isNotEmpty) {
      listStudentTypesString = listStudentTypes.map((studentType) {
        return studentType['name'] as String;
      }).toList();
    }

    return StudentProfile(
      name: map['name'] as String?,
      id: map['code'] as String?,
      email: map['email'] as String?,
      birthdate: map['dob'] as String?,
      gender: map['gender']['name'] as String?,
      schoolCourse: map['course'] as String?,
      image: profile['image_file'] as String?,

      tinhKhaisinh: profile['birth_city'] as String?,
      huyenKhaisinh: profile['birth_district'] as String?,
      xaKhaisinh: profile['birth_ward'] as String?,
      tinhThuongtru: profile['residence_city'] as String?,
      huyenThuongtru: profile['residence_district'] as String?,
      xaThuongtru: profile['residence_ward'] as String?,
      identityId: profile['identity_number'] as String?,
      identityDate: profile['identity_date'] as String?,
      identityAddress: profile['identity_place'] as String?,
      phoneContact: profile['phone_number'] as String?,
      emailContact: profile['email'] as String?,
      ethnicity: profile['ethnic']['name'] as String?,
      religion: profile['religion']['name'] as String?,
      admissionCode: profile['admission_code']['name'] as String?,
      admissionDate: profile['admission_date'] as String?,
      healthInsuranceId: profile['health_insurance_code'] as String?,
      householdName: profile['householder_name'] as String?,
      householdBirthdate: profile['householder_dob'] as String?,
      householdGender: profile['householder_gender']['name'] as String?,
      relativeWithHousehold: profile['householder_relationship'] as String?,
      fatherName: profile['father_name'] as String?,
      fatherBirthdate: profile['father_dob'] as String?,
      fatherPhone: profile['father_phone_number'] as String?,
      fatherJob: profile['father_job'] as String?,
      motherName: profile['mother_name'] as String?,
      motherBirthdate: profile['mother_dob'] as String?,
      motherPhone: profile['mother_phone_number'] as String?,
      motherJob: profile['mother_job'] as String?,
      mailingAddress: profile['mailing_address'] as String?,
      studentTypes: listStudentTypesString,
      feeTypes: profile['tuition_fee_type']['name'] as String?,
    );
  }

  @override
  String toString() {
    return 'StudentProfile(name: $name, id: $id, image: $image, birthdate: $birthdate, gender: $gender, schoolCourse: $schoolCourse, tinhKhaisinh: $tinhKhaisinh, huyenKhaisinh: $huyenKhaisinh, xaKhaisinh: $xaKhaisinh, tinhThuongtru: $tinhThuongtru, huyenThuongtru: $huyenThuongtru, xaThuongtru: $xaThuongtru, identifyId: $identityId, identifyDate: $identityDate, identifyAddress: $identityAddress, phoneContact: $phoneContact, emailContact: $emailContact, ethnicity: $ethnicity, religion: $religion, admissionCode: $admissionCode, admissionDate: $admissionDate, healthInsuranceId: $healthInsuranceId, householdName: $householdName, householdBirthdate: $householdBirthdate, householdGender: $householdGender, relativeWithHousehold: $relativeWithHousehold, fatherName: $fatherName, fatherBirthdate: $fatherBirthdate, fatherPhone: $fatherPhone, fatherJob: $fatherJob, motherName: $motherName, motherBirthdate: $motherBirthdate, motherPhone: $motherPhone, motherJob: $motherJob, mailingAddress: $mailingAddress, studentTypes: $studentTypes, feeTypes: $feeTypes)';
  }
}
