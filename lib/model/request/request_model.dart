import 'package:datn/constants/constant_list.dart';
import 'package:datn/function/function.dart';
import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/login/user.dart';
import 'package:datn/model/request/request_information_model.dart';

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
    this.info,
    this.file
  });

  factory Request.fromJson(Map<String, dynamic> json) {

    final localDateCreate = formatDateWithTime(json['created_date'] as String, outputIncludeTime: true);
    final localDateReceive = formatDateWithTime(json['receive_date'] as String?, outputIncludeTime: true);
    
    String? requestFee;
    if (json['fee'] is int) {
      requestFee = "${json['fee'] as int}đ";
    } else {
      requestFee = "${int.tryParse(json['fee'] as String)}đ";
    }

    return Request(
      id: json['id'] as int,
      user: User.fromJson(json['user'] as Map<String,dynamic>),
      requestType: json['type']['name'] as String?,
      requestTypeId: json['type']['id'] as int,
      documentNeed: json['document_need'] as String?,
      statusId: json['status']['id'] as int?,
      status: json['status']['name'] as String,
      fee: json['fee'] != null ? "${json['fee']}đ" : null,
      // fee: requestFee,
      processingPlace: json['processing_place']['name'] as String?,
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
