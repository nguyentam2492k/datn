import 'package:datn/function/function.dart';

class OtherInformation {
  List<String>? studentTypes;
  String? feeTypes;
  OtherInformation({
    this.studentTypes,
    this.feeTypes,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'student_types': studentTypes,
      'fee_types': feeTypes,
    };
  }

  factory OtherInformation.fromJson(Map<String, dynamic> json) {
    return OtherInformation(
      studentTypes: json['student_types'] != null ? toListString(json["student_types"]) : null,
      feeTypes: json['fee_types'] != null ? json['fee_types'] as String : null,
    );
  }
}
