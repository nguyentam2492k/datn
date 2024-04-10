import 'package:datn/function/function.dart';
import 'package:datn/model/request/request_information_model.dart';
import 'package:datn/model/student/student_profile.dart';

class GetDataResponseModel {
  int totalRequests;
  List<Request> listRequests;
  
  GetDataResponseModel({
    required this.totalRequests,
    required this.listRequests,
  });
}

class Request {
  int id;
  StudentProfile? user;
  String? requestType;
  int requestTypeId;
  String? documentNeed;
  String status;
  int? statusId;
  String? fee;
  String? processingPlace;
  String dateCreate;
  String? dateReceive;
  String? expireIn;
  RequestInformation? info;
  List<String>? file;

  Request({
    required this.id,
    this.user,
    this.requestType,
    required this.requestTypeId,
    this.documentNeed,
    required this.status,
    this.statusId,
    this.fee,
    this.processingPlace,
    required this.dateCreate,
    this.dateReceive,
    this.expireIn,
    this.info,
    this.file
  });

  factory Request.fromJson(Map<String, dynamic> json) {

    final localDateCreate = formatDateWithTime(json['created_date'] as String, outputIncludeTime: true);
    final localDateReceive = formatDateWithTime(json['receive_date'] as String?, outputIncludeTime: true);

    final date = getDateFromString(json['created_date'] as String);
    final expire = json['expire_in'] as int?;
    final localExpireDate = (date != null && expire != null) ? "${formatDateWithTime(addDateToDateTime(date, expire).toString())}" : null;

    return Request(
      id: json['id'] as int,
      user: StudentProfile.fromJson(json['user'] as Map<String,dynamic>),
      requestType: json['type']['name'] as String?,
      requestTypeId: json['type']['id'] as int,
      documentNeed: json['document_need'] as String?,
      statusId: json['status']['id'] as int?,
      status: json['status']['name'] as String,
      fee: json['fee'] != null ? "${json['fee']}đ" : null,
      processingPlace: json['processing_place']['name'] as String?,
      dateCreate: localDateCreate ?? json['created_date'] as String,
      dateReceive: localDateReceive,
      expireIn: localExpireDate,
      info: RequestInformation.fromJson(json['info'] as Map<String,dynamic>),
      file: json['info']['files'] != null ? toListString(json['info']['files']) : null, 
    );
  }

}
