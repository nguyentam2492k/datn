import 'package:datn/constants/constant_list.dart';
import 'package:datn/function/function.dart';
import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/login/user.dart';
import 'package:datn/model/request/request_information_model.dart';

// class Request {
//   int? id;
//   String? student;
//   String? userId;
//   String? requestType;
//   int requestTypeId;
//   RequestInformation? info;
//   List<String>? file;
//   String? documentNeed;
//   String status;
//   String? fee;
//   String? processingPlace;
//   String dateCreate;
//   String? dateReceive;

//   Request({
//     this.id,
//     this.student,
//     this.userId,
//     this.requestType,
//     required this.requestTypeId,
//     this.info,
//     this.file,
//     required this.documentNeed,
//     required this.status,
//     required this.fee,
//     this.processingPlace,
//     required this.dateCreate,
//     this.dateReceive,
//   });

//   factory Request.fromJson(Map<String, dynamic> json) {

//     var info = RequestInformation.fromJson(json["info"] as Map<String,dynamic>);

//     return Request(
//       id: json["id"] as int?, 
//       student: json["student"] as String?, 
//       userId: json["userId"] as String?,
//       requestType: json["request_type"] as String?, 
//       requestTypeId: json["request_type_id"] as int,
//       info: info, 
//       file: json['file'] != null ? toListString(json["file"]) : null, 
//       documentNeed: json["document_need"] as String?, 
//       status: json["status"] as String, 
//       fee: json["fee"] as String?, 
//       processingPlace: json["processing_place"] as String?, 
//       dateCreate: json["date_create"] as String, 
//       dateReceive: json["date_receive"] as String?,
//     );
//   }

//   @override
//   String toString() {
//     return 'RequestInformation(id: $id, student: $student, requestType: $requestType, requestTypeId: $requestTypeId, file: $file, documentNeed: $documentNeed, status: $status, fee: $fee, processingPlace: $processingPlace, dateCreate: $dateCreate, dateReceive: $dateReceive)';
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'student': globalLoginResponse!.user?.name ?? "Nguyen Van A",
//       'userId': globalLoginResponse!.user?.id ?? "18021117",
//       'request_type': ConstantList.requests[requestTypeId - 1],
//       'request_type_id': requestTypeId,
//       'file': file,
//       'document_need': documentNeed ?? "Không",
//       'status': status,
//       'fee': fee ?? "10.000",
//       'processing_place': processingPlace ?? "Phòng công tác Sinh viên",
//       'date_create': dateCreate,
//       'date_receive': dateReceive,
//     };
//   }

// }



class GetDataResponseModel {
  int totalRequests;
  List<Request> listRequests;
  
  GetDataResponseModel({
    required this.totalRequests,
    required this.listRequests,
  });
}

class Request {
  //   int? id;
//   String? student;
//   String? userId;
//   String? requestType;
//   int requestTypeId;
//   RequestInformation? info;
//   List<String>? file;
//   String? documentNeed;
//   String status;
//   String? fee;
//   String? processingPlace;
//   String dateCreate;
//   String? dateReceive;
  int? id;
  User? user;
  String? requestType;
  int requestTypeId;
  String? documentNeed;
  String status;
  int? statusId;
  String? fee;
  String? processingPlace;
  String dateCreate;
  String? dateReceive;
  RequestInformation? info;
  List<String>? file;

  Request({
    this.id,
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
    this.info,
    this.file
  });

  factory Request.fromJson(Map<String, dynamic> json) {

    final localDateCreate = formatDateWithTime(json['created_date'] as String);
    final localDateReceive = formatDateWithTime(json['receive_date'] as String?);

    return Request(
      id: json['id'] as int?,
      user: User.fromJson(json['user'] as Map<String,dynamic>),
      requestType: json['type']['name'] as String?,
      requestTypeId: json['type']['id'] as int,
      documentNeed: json['document_need'] as String?,
      statusId: json['status']['id'] as int?,
      status: json['status']['name'] as String,
      fee: json['fee'] != null ? "${json['fee'] as String}đ" : null,
      processingPlace: json['processing_place'] as String?,
      dateCreate: localDateCreate ?? json['created_date'] as String,
      dateReceive: localDateReceive,
      info: RequestInformation.fromJson(json['info'] as Map<String,dynamic>),
      file: json['info']['files'] != null ? toListString(json['info']['files']) : null, 
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'student': globalLoginResponse!.user?.name ?? "Nguyen Van A",
      'userId': globalLoginResponse!.user?.id ?? "18021117",
      'request_type': ConstantList.requests[requestTypeId - 1],
      'request_type_id': requestTypeId,
      'file': file,
      'document_need': documentNeed ?? "Không",
      'status': status,
      'fee': fee ?? "10.000",
      'processing_place': processingPlace ?? "Phòng công tác Sinh viên",
      'date_create': dateCreate,
      'date_receive': dateReceive,
    };
  }
}
