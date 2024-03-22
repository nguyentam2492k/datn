import 'package:datn/function/function.dart';

class RequestInformation {

  int? quantityViet;
  int? quantityEng;
  String? reason;
  String? phoneContact;
  String? year;
  String? startDate;
  String? endDate;
  
  //Request 1
  String? certificateType;

  //Request 2
  String? semesterType;
  List<String>? semesterNumber;
  String? transcriptType;

  //Request 3
  String? subject;
  String? lecturer;
  String? examDate;

  //Request 4
  String? subjectReview;
  String? semester;

  //Request 6
  List<String>? documents;
  String? otherDocument;

  //Request 8
  String? monthFee;

  //Requet 17
  String? tuyen;
  String? mottuyen;
  String? studentAddress;
  String? receivingPlace;

  //Request 19
  String? name;
  String? doituonguutien;
  String? permanentAddress;
  String? email;
  String? khicanbaotin;

  //Request 20+22
  String? educationProgram;
  String? internCompany;

  RequestInformation({
    this.quantityViet,
    this.quantityEng,
    this.reason,
    this.phoneContact,
    this.startDate,
    this.endDate,
    this.certificateType,
    this.semesterType,
    this.semesterNumber,
    this.transcriptType,
    this.subject,
    this.lecturer,
    this.examDate,
    this.subjectReview,
    this.semester,
    this.year,
    this.documents,
    this.otherDocument,
    this.monthFee,
    this.tuyen,
    this.mottuyen,
    this.studentAddress,
    this.receivingPlace,
    this.name,
    this.doituonguutien,
    this.permanentAddress,
    this.email,
    this.khicanbaotin,
    this.educationProgram,
    this.internCompany
  });

  factory RequestInformation.fromJson(Map<String, dynamic> json) {
    var examDate = formatDateWithTime(json['exam_date'] as String?);

    var localStartDate = formatDateWithTime(json['start_date'] as String?);
    var localEndDate = formatDateWithTime(json['end_date'] as String?);

    return RequestInformation(
      quantityViet: json['quantity_viet'] as int?,
      quantityEng: json['quantity_eng'] as int?,
      reason: json['reason'] as String?,
      phoneContact: json['phone_contact'] as String?,
      startDate: localStartDate,
      endDate: localEndDate,
      year: json['year'] as String?,

      certificateType: json['certificate_type'] as String?,
      semesterType: json['semester_type'] as String?,
      semesterNumber: json['semester_number'] != null ? toListString(json["semester_number"]) : null,
      transcriptType: json['transcript_type'] as String?,
      subject: json['subject'] as String?,
      lecturer: json['lecturer'] as String?,
      examDate: examDate,
      subjectReview: json['subject_review'] as String?,
      semester: json['semester'] as String?,
      documents: json['documents'] != null ? toListString(json["documents"]) : null,
      otherDocument: json['other_document'] as String?,
      monthFee: json['month_fee'] as String?,
      tuyen: json['interline_bus_type'] as String?,
      mottuyen: json['bus_number'] as String?,
      studentAddress: json['student_address'] as String?,
      receivingPlace: json['receiving_place'] as String?,
      name: json['name'] as String?,
      doituonguutien: json['doituonguutien'] as String?,
      permanentAddress: json['permanent_address'] as String?,
      email: json['email'] as String?,
      khicanbaotin: json['khicanbaotin'] as String?,
      educationProgram: json['education_program'] as String?,
      internCompany: json['intern_company'] as String?
    );
  }
}
