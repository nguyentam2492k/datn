import 'package:datn/function/function.dart';

class RequestInformation {

  String? quantityViet;
  String? quantityEng;
  String? reason;
  String? phoneContact;
  
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
  String? year;

  //Request 5
  String? untilDate;

  //Request 6
  List<String>? documents;
  String? otherDocument;
  String? borrowDate;

  //Request 8
  String? monthFee;

  //Request 11
  String? absentDate;

  //Requet 17
  String? tuyen;
  String? mottuyen;
  String? studentAddress;
  String? receivingPlace;

  //Request 18
  String? name;
  String? rentDate;
  String? doituonguutien;
  String? permanentAddress;
  String? email;
  String? khicanbaotin;

  RequestInformation({
    this.quantityViet,
    this.quantityEng,
    this.reason,
    this.phoneContact,
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
    this.untilDate,
    this.documents,
    this.otherDocument,
    this.borrowDate,
    this.monthFee,
    this.absentDate,
    this.tuyen,
    this.mottuyen,
    this.studentAddress,
    this.receivingPlace,
    this.name,
    this.rentDate,
    this.doituonguutien,
    this.permanentAddress,
    this.email,
    this.khicanbaotin,
  });

  factory RequestInformation.fromJson(Map<String, dynamic> json) {
    var examDate = formatDate(json['exam_date'] as String?);
    var untilDate = formatDate(json['until_date'] as String?);

    var borrowDate = formatDateRange(json["borrow_date"]);
    var absentDate = formatDateRange(json["absent_date"]);
    var rentDate = formatDateRange(json["rent_date"]);

    return RequestInformation(
      quantityViet: json['quantity_viet'] as String?,
      quantityEng: json['quantity_eng'] as String?,
      reason: json['reason'] as String?,
      phoneContact: json['phone_contact'] as String?,
      certificateType: json['certificate_type'] as String?,
      semesterType: json['semester_type'] as String?,
      semesterNumber: json['semester_number'] != null ? toListString(json["semester_number"]) : null,
      transcriptType: json['transcript_type'] as String?,
      subject: json['subject'] as String?,
      lecturer: json['lecturer'] as String?,
      examDate: examDate,
      subjectReview: json['subject_review'] as String?,
      semester: json['semester'] as String?,
      year: json['year'] as String?,
      untilDate: untilDate,
      documents: json['documents'] != null ? toListString(json["documents"]) : null,
      otherDocument: json['other_document'] as String?,
      borrowDate: borrowDate,
      monthFee: json['month_fee'] as String?,
      absentDate: absentDate,
      tuyen: json['tuyen'] as String?,
      mottuyen: json['mottuyen'] as String?,
      studentAddress: json['student_address'] as String?,
      receivingPlace: json['receiving_place'] as String?,
      name: json['name'] as String?,
      rentDate: rentDate,
      doituonguutien: json['doituonguutien'] as String?,
      permanentAddress: json['permanent_address'] as String?,
      email: json['email'] as String?,
      khicanbaotin: json['khicanbaotin'] as String?,
    );
  }
}
