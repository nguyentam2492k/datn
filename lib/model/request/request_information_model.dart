// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:datn/model/request/request_type_model.dart';

class RequestInformation {
  String id;
  String student;
  String requestType;
  String requestTypeId;
  dynamic info;
  List<String>? file;
  String documentNeed;
  String status;
  String? fee;
  String processingPlace;
  String dateCreate;
  String? dateReceive;

  RequestInformation({
    required this.id,
    required this.student,
    required this.requestType,
    required this.requestTypeId,
    required this.info,
    this.file,
    required this.documentNeed,
    required this.status,
    this.fee,
    required this.processingPlace,
    required this.dateCreate,
    this.dateReceive,
  });

  factory RequestInformation.fromJson(Map<String, dynamic> json) {

    String requestTypeId = json["request_type_id"] as String;
    var info = json["info"];

    List<String> toListString(List list) {
      return list.map((item) => item as String).toList();
    }

    if (requestTypeId == "1") {
      info = Request1Model.fromJson(json["info"]);
    }

    return RequestInformation(
      id: json["id"] as String, 
      student: json["student"] as String, 
      requestType: json["request_type"] as String, 
      requestTypeId: requestTypeId,
      info: info, 
      file: json["file"] != null ? toListString(json["file"]) : null, 
      documentNeed: json["document_need"] as String, 
      status: json["status"] as String, 
      fee: json["fee"] as String?, 
      processingPlace: json["processing_place"] as String, 
      dateCreate: json["date_create"] as String, 
      dateReceive: json["date_receive"] as String?,
    );
  }

  @override
  String toString() {
    return 'RequestInformation(id: $id, student: $student, requestType: $requestType, requestTypeId: $requestTypeId, file: $file, documentNeed: $documentNeed, status: $status, fee: $fee, processingPlace: $processingPlace, dateCreate: $dateCreate, dateReceive: $dateReceive)';
  }
}
