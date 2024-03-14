import 'package:datn/model/student/family_information.dart';
import 'package:datn/model/student/other_information.dart';
import 'package:datn/model/student/personal_information.dart';

class StudentInformation {
  String name;
  String id;
  String? image;
  String birthdate;
  String gender;
  String schoolYear;
  PersonalInformation personalInformation;
  FamilyInformation familyInformation;
  OtherInformation otherInformation;

  StudentInformation({
    required this.name,
    required this.id,
    this.image,
    required this.birthdate,
    required this.gender,
    required this.schoolYear,
    required this.personalInformation,
    required this.familyInformation,
    required this.otherInformation,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'image': image,
      'birthdate': birthdate,
      'gender': gender,
      'school_year': schoolYear,
      'personal_information': personalInformation.toMap(),
      'family_information': familyInformation.toMap(),
      'other_information': otherInformation.toMap(),
    };
  }

  factory StudentInformation.fromMap(Map<String, dynamic> map) {
    return StudentInformation(
      name: map['name'] as String,
      id: map['id'] as String,
      image: map['image'] as String?,
      birthdate: map['birthdate'] as String,
      gender: map['gender'] as String,
      schoolYear: map['school_year'] as String,
      personalInformation: PersonalInformation.fromJson(map['personal_information'] as Map<String,dynamic>),
      familyInformation: FamilyInformation.fromJson(map['family_information'] as Map<String,dynamic>),
      otherInformation: OtherInformation.fromJson(map['other_information'] as Map<String,dynamic>),
    );
  }
}
