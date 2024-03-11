class FamilyInformation {
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

  FamilyInformation({
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
    this.mailingAddress, //Dia chi hom thu cua gia dinh
  });

  factory FamilyInformation.fromJson(Map<String, dynamic> map) {
    return FamilyInformation(
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
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'household_name': householdName,
      'household_birthdate': householdBirthdate,
      'household_gender': householdGender,
      'relative_with_household': relativeWithHousehold,
      'father_name': fatherName,
      'father_birthdate': fatherBirthdate,
      'father_phone': fatherPhone,
      'father_job': fatherJob,
      'mother_name': motherName,
      'mother_birthdate': motherBirthdate,
      'mother_phone': motherPhone,
      'mother_job': motherJob,
      'mailing_address': mailingAddress,
    };
  }
}
