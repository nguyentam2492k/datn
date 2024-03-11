class PersonalInformation {
  String? tinhKhaisinh;
  String? huyenKhaisinh;
  String? xaKhaisinh;
  String? tinhThuongtru;
  String? huyenThuongtru;
  String? xaThuongtru;
  String? indentifyId;
  String? indentifyDate;
  String? indentifyAddress;
  String? phoneContact;
  String? emailContact;
  String? ethnicity;
  String? religion;
  String? admissionCode; //Ma xet tuyen
  String? admissionDate;
  String? healthInsuranceId; //Ma bao hiem y te
  
  PersonalInformation({
    this.tinhKhaisinh,
    this.huyenKhaisinh,
    this.xaKhaisinh,
    this.tinhThuongtru,
    this.huyenThuongtru,
    this.xaThuongtru,
    this.indentifyId,
    this.indentifyDate,
    this.indentifyAddress,
    this.phoneContact,
    this.emailContact,
    this.ethnicity,
    this.religion,
    this.admissionCode,
    this.admissionDate,
    this.healthInsuranceId,
  });

  factory PersonalInformation.fromJson(Map<String, dynamic> map) {
    return PersonalInformation(
      tinhKhaisinh: map['tinh_khaisinh'] != null ? map['tinh_khaisinh'] as String : null,
      huyenKhaisinh: map['huyen_khaisinh'] != null ? map['huyen_khaisinh'] as String : null,
      xaKhaisinh: map['xa_khaisinh'] != null ? map['xa_khaisinh'] as String : null,
      tinhThuongtru: map['tinh_thuongtru'] != null ? map['tinh_thuongtru'] as String : null,
      huyenThuongtru: map['huyen_thuongtru'] != null ? map['huyen_thuongtru'] as String : null,
      xaThuongtru: map['xa_thuongtru'] != null ? map['xa_thuongtru'] as String : null,
      indentifyId: map['indentify_id'] != null ? map['indentify_id'] as String : null,
      indentifyDate: map['indentify_date'] != null ? map['indentify_date'] as String : null,
      indentifyAddress: map['indentify_address'] != null ? map['indentify_address'] as String : null,
      phoneContact: map['phone_contact'] != null ? map['phone_contact'] as String : null,
      emailContact: map['email_contact'] != null ? map['email_contact'] as String : null,
      ethnicity: map['ethnicity'] != null ? map['ethnicity'] as String : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      admissionCode: map['admission_code'] != null ? map['admission_code'] as String : null,
      admissionDate: map['admission_date'] != null ? map['admission_date'] as String : null,
      healthInsuranceId: map['health_insurance_id'] != null ? map['health_insurance_id'] as String : null,
    );
  }
  
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tinh_khaisinh': tinhKhaisinh,
      'huyen_khaisinh': huyenKhaisinh,
      'xa_khaisinh': xaKhaisinh,
      'tinh_thuongtru': tinhThuongtru,
      'huyen_thuongtru': huyenThuongtru,
      'xa_thuongtru': xaThuongtru,
      'indentify_id': indentifyId,
      'indentify_date': indentifyDate,
      'indentify_address': indentifyAddress,
      'phone_contact': phoneContact,
      'email_contact': emailContact,
      'ethnicity': ethnicity,
      'religion': religion,
      'admission_code': admissionCode,
      'admission_date': admissionDate,
      'health_insurance_id': healthInsuranceId,
    };
  }
}
