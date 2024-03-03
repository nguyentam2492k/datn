import 'package:datn/constants/constant_list.dart';
import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/request/file_data_model.dart';
import 'package:datn/model/request/request_information_model.dart';

class Request {
  int? id;
  String? student;
  String? userId;
  String? requestType;
  int requestTypeId;
  RequestInformation? info;
  List<FileData>? file;
  String? documentNeed;
  String status;
  String? fee;
  String? processingPlace;
  String dateCreate;
  String? dateReceive;

  Request({
    this.id,
    this.student,
    this.userId,
    this.requestType,
    required this.requestTypeId,
    this.info,
    required this.file,
    this.documentNeed,
    required this.status,
    this.fee,
    this.processingPlace,
    required this.dateCreate,
    this.dateReceive,
  });

  factory Request.fromJson(Map<String, dynamic> json) {

    var info = RequestInformation.fromJson(json["info"]);

    List<FileData>? listFiles;
    if (json['file'] != null) {
      var listFilesJson = json['file'] as List;
      listFiles = listFilesJson.map((fileJson) => FileData.fromJson(fileJson)).toList();
    }

    return Request(
      id: json["id"] as int?, 
      student: json["student"] as String?, 
      userId: json["userId"] as String?,
      requestType: json["request_type"] as String?, 
      requestTypeId: json["request_type_id"] as int,
      info: info, 
      file: listFiles, 
      documentNeed: json["document_need"] as String?, 
      status: json["status"] as String, 
      fee: json["fee"] as String?, 
      processingPlace: json["processing_place"] as String?, 
      dateCreate: json["date_create"] as String, 
      dateReceive: json["date_receive"] as String?,
    );
  }

  @override
  String toString() {
    return 'RequestInformation(id: $id, student: $student, requestType: $requestType, requestTypeId: $requestTypeId, file: $file, documentNeed: $documentNeed, status: $status, fee: $fee, processingPlace: $processingPlace, dateCreate: $dateCreate, dateReceive: $dateReceive)';
  }

  Map<String, dynamic> toMap() {

    List<Map<String, dynamic>>? listFile;
    if (file != null) {
      listFile = file?.map((item) => item.toMap()).toList();
    }

    return <String, dynamic>{
      'student': globalLoginResponse!.user.name,
      'userId': globalLoginResponse!.user.id,
      'request_type': ConstantList.requests[requestTypeId - 1],
      'request_type_id': requestTypeId,
      'file': listFile,
      'document_need': documentNeed ?? "Không",
      'status': status,
      'fee': fee ?? "10.000",
      'processing_place': processingPlace ?? "Phòng công tác Sinh viên",
      'date_create': dateCreate,
      'date_receive': dateReceive,
    };
  }

}
