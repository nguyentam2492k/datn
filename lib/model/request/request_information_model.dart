// ignore_for_file: public_member_api_docs, sort_constructors_first

class RequestInformation {
  String id;
  String student;
  String requestType;
  // dynamic info;
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
    // required this.info,
    this.file,
    required this.documentNeed,
    required this.status,
    this.fee,
    required this.processingPlace,
    required this.dateCreate,
    this.dateReceive,
  });

  factory RequestInformation.fromJson(Map<String, dynamic> json) {
    List<String> toListString(List list) {
      return list.map((item) => item as String).toList();
    }

    return RequestInformation(
      id: json["id"] as String, 
      student: json["student"] as String, 
      requestType: json["request_type"] as String, 
      // info: json["info"], 
      file: json["file"] != null ? toListString(json["file"]) : null, 
      documentNeed: json["document_need"] as String, 
      status: json["status"] as String, 
      fee: json["fee"] as String?, 
      processingPlace: json["processing_place"] as String, 
      dateCreate: json["date_create"] as String, 
      dateReceive: json["date_receive"] as String?
    );
  }

  @override
  String toString() {
    return 'RequestInformation(id: $id, student: $student, requestType: $requestType, file: $file, documentNeed: $documentNeed, status: $status, fee: $fee, processingPlace: $processingPlace, dateCreate: $dateCreate, dateReceive: $dateReceive)';
  }
}
