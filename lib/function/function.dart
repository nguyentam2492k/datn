import 'dart:convert';
import 'dart:io';

import 'package:datn/model/request/request_information_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

String formatDateWithTime(String dateWithTime) {
  var inputFormat = DateFormat('yyyy-MM-dd hh:mm');
  var inputDate = inputFormat.parse(dateWithTime);
  
  var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String? formatDate(String? date) {
  if (date == null) {
    return null;
  }

  var inputFormat = DateFormat('yyyy-MM-dd hh:mm');
  var inputDate = inputFormat.parse(date);
  
  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String? formatDateRange(String? dateRange) {
  if (dateRange == null) {
    return null;
  }

  var date = dateRange.split(" - ");

  var inputFormat = DateFormat('yyyy-MM-dd hh:mm');
  // var inputDate = inputFormat.parse(dateRange);
  
  var outputFormat = DateFormat('dd/MM/yyyy');
  return "${outputFormat.format(inputFormat.parse(date[0]))} - ${outputFormat.format(inputFormat.parse(date[1]))}";
}

bool isInteger(String? s) {
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}

Future<String> fileToBase64(File file) async {
  List<int> imageBytes = await file.readAsBytes();
  return base64Encode(imageBytes);
}

Future<File> imageToFile() async {
  ByteData bytes = await rootBundle.load('assets/images/uet.png');
  String tempPath = (await getTemporaryDirectory()).path;
  File file = File('$tempPath/image.jpg');
  await file.writeAsBytes(
    bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes)
  );
  return file;
}

Color getColor(String status) {
  switch (status) {
    case "completed":
      return Colors.green;
    case "canceled":
      return Colors.red;
    case "processing":
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}

String listToString(List<String> listString) {
  var string = StringBuffer();
  string.writeAll(listString, ", ");
  return string.toString().trim();
}

List<String> toListString(List list) {
  var listString =  list.map((item) => item as String).toList();
  listString.sort();
  return listString;
}

String getRequestText(RequestInformation requestInfo) {
  var requestText = StringBuffer();
  requestInfo.certificateType != null ? requestText.writeln("Loại GCN: ${requestInfo.certificateType}") : null;
  requestInfo.semesterType != null ? requestText.writeln("Loại kỳ: ${requestInfo.semesterType}") : null;
  requestInfo.semesterNumber != null ? requestText.writeln("Kỳ: ${listToString(requestInfo.semesterNumber!)}") : null;
  requestInfo.transcriptType != null ? requestText.writeln("Loại bảng điểm: ${requestInfo.transcriptType}") : null;
  requestInfo.subject != null ? requestText.writeln("Môn học: ${requestInfo.subject}") : null;
  requestInfo.lecturer != null ? requestText.writeln("Giảng viên: ${requestInfo.lecturer}") : null;
  requestInfo.examDate != null ? requestText.writeln("Ngày thi: ${requestInfo.examDate}") : null;
  requestInfo.subjectReview != null ? requestText.writeln("Học phần: ${requestInfo.subjectReview}") : null;
  requestInfo.semester != null ? requestText.writeln("Học kỳ: ${requestInfo.semester}") : null;
  requestInfo.educationProgram != null ? requestText.writeln("Chương trình đào tạo: ${requestInfo.educationProgram}") : null;
  requestInfo.year != null ? requestText.writeln("Năm học: ${requestInfo.year}") : null;
  requestInfo.untilDate != null ? requestText.writeln("Đến ngày: ${requestInfo.untilDate}") : null;
  requestInfo.documents != null ? requestText.writeln("Hồ sơ mượn: ${listToString(requestInfo.documents!)}") : null;
  requestInfo.otherDocument != null ? requestText.writeln("Hồ sơ khác: ${requestInfo.otherDocument}") : null;
  requestInfo.borrowDate != null ? requestText.writeln("Thời gian mượn: ${requestInfo.borrowDate}") : null;
  requestInfo.monthFee != null ? requestText.writeln("Học phí theo tháng: ${requestInfo.monthFee}") : null;
  requestInfo.absentDate != null ? requestText.writeln("Thời gian nghỉ: ${requestInfo.absentDate}") : null;
  requestInfo.tuyen != null ? requestText.writeln("Tuyến đăng ký: ${requestInfo.tuyen}") : null;
  requestInfo.mottuyen != null ? requestText.writeln("Tuyến số: ${requestInfo.mottuyen}") : null;
  requestInfo.studentAddress != null ? requestText.writeln("Địa chỉ: ${requestInfo.studentAddress}") : null;
  requestInfo.name != null ? requestText.writeln("Đơn nguyên: ${requestInfo.name}") : null;
  requestInfo.rentDate != null ? requestText.writeln("Thời gian thuê: ${requestInfo.rentDate}") : null;
  requestInfo.doituonguutien != null ? requestText.writeln("Đối tượng ưu tiên: ${requestInfo.doituonguutien}") : null;
  requestInfo.permanentAddress != null ? requestText.writeln("Địa chỉ thường trú: ${requestInfo.permanentAddress}") : null;
  requestInfo.phoneContact != null ? requestText.writeln("SĐT: ${requestInfo.phoneContact}") : null;
  requestInfo.receivingPlace != null ? requestText.writeln("Nơi nộp đơn và nhận thẻ: ${requestInfo.receivingPlace}") : null;
  requestInfo.email != null ? requestText.writeln("Email: ${requestInfo.email}") : null;
  requestInfo.khicanbaotin != null ? requestText.writeln("Khi cần liên hệ: ${requestInfo.khicanbaotin}") : null;
  requestInfo.internCompany != null ? requestText.writeln("Nơi thực tập: ${requestInfo.internCompany}") : null;
  (requestInfo.quantityViet != null && requestInfo.quantityViet != "0") ? requestText.writeln("Số bản tiếng Việt: ${requestInfo.quantityViet}") : null;
  (requestInfo.quantityEng != null && requestInfo.quantityEng != "0") ? requestText.writeln("Số bản tiếng Anh: ${requestInfo.quantityEng}") : null;
  requestInfo.reason != null ? requestText.writeln("Lý do: ${requestInfo.reason}") : null;
  return requestText.toString().trim();
}

String getStatus(String status) {
  switch (status) {
    case "completed":
      return "Đã xong";
    case "canceled":
      return "Đã huỷ";
    case "processing":
      return "Đang xử lý";
    default:
      return "----";
  }
}

IconData getIcon(String fileName) {
  final mimeType = lookupMimeType(fileName);
  if (mimeType == null) {
    return Icons.text_snippet_outlined;
  }
  if (mimeType.startsWith("image/")) {
    return Icons.image_outlined;
  }
  if (mimeType.endsWith("/pdf")) {
    return Icons.picture_as_pdf_outlined;
  }
  return Icons.text_snippet_outlined;
}

String getFileNameFromUrl(String url) {
  if (url.isEmpty) {
    return "noname";
  }
  Uri uri = Uri.parse(url);
  String fileName = uri.pathSegments.last.split("/").last;
  return fileName;
}

bool isListFileOK(List<PlatformFile> listPlatformFile) {
  bool isFileOK = true;
  var listFileNull = listPlatformFile.where((element) => element.path == null).toList();
  for (var platformFile in listPlatformFile) {
    var file = File(platformFile.path!);
    if (!file.existsSync()) {
      isFileOK = false;
      break;
    }
  }
  return listFileNull.isEmpty && isFileOK;
}