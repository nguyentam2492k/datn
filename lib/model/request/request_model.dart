// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:datn/model/request/file_data_model.dart';
import 'package:datn/model/request/request_details_model.dart';

class Request {
  int id;
  String student;
  String requestType;
  String requestTypeId;
  RequestDetails info;
  List<FileData>? file;
  String documentNeed;
  String status;
  String? fee;
  String processingPlace;
  String dateCreate;
  String? dateReceive;

  Request({
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

  factory Request.fromJson(Map<String, dynamic> json) {

    String requestTypeId = json["request_type_id"] as String;
    var info = RequestDetails.fromJson(json["info"]);

    List<String> toListString(List list) {
      return list.map((item) => item as String).toList();
    }

    List<FileData>? listFiles;
    if (json['file'] != null) {
      var listFilesJson = json['file'] as List;
      listFiles = listFilesJson.map((fileJson) => FileData.fromJson(fileJson)).toList();
    }

    return Request(
      id: json["id"] as int, 
      student: json["student"] as String, 
      requestType: json["request_type"] as String, 
      requestTypeId: requestTypeId,
      info: info, 
      file: listFiles, 
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
