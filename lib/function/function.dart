import 'dart:convert';
import 'dart:io';

import 'package:datn/model/request/request_details_model.dart';
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

//NOTE: CHECK WHETHER STRING IS INTEGER OR NOT
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

String getRequestText(RequestDetails requestDetails) {
  var requestText = StringBuffer();
  requestDetails.certificateType != null ? requestText.writeln("Loại GCN: ${requestDetails.certificateType}") : null;
  requestDetails.semesterType != null ? requestText.writeln("Loại kỳ: ${requestDetails.semesterType}") : null;
  requestDetails.semesterNumber != null ? requestText.writeln("Kỳ: ${listToString(requestDetails.semesterNumber!)}") : null;
  requestDetails.transcriptType != null ? requestText.writeln("Loại bảng điểm: ${requestDetails.transcriptType}") : null;
  requestDetails.subject != null ? requestText.writeln("Môn học: ${requestDetails.subject}") : null;
  requestDetails.lecturer != null ? requestText.writeln("Giảng viên: ${requestDetails.lecturer}") : null;
  requestDetails.examDate != null ? requestText.writeln("Ngày thi: ${requestDetails.examDate}") : null;
  requestDetails.subjectReview != null ? requestText.writeln("Học phần: ${requestDetails.subjectReview}") : null;
  requestDetails.semester != null ? requestText.writeln("Học kỳ: ${requestDetails.semester}") : null;
  requestDetails.year != null ? requestText.writeln("Năm học: ${requestDetails.year}") : null;
  requestDetails.untilDate != null ? requestText.writeln("Đến ngày: ${requestDetails.untilDate}") : null;
  requestDetails.documentType != null ? requestText.writeln("Hồ sơ mượn: ${requestDetails.documentType}") : null;
  requestDetails.otherDocument != null ? requestText.writeln("Hồ sơ khác: ${requestDetails.otherDocument}") : null;
  requestDetails.borrowDate != null ? requestText.writeln("Thời gian mượn: ${requestDetails.borrowDate}") : null;
  requestDetails.absentDate != null ? requestText.writeln("Thời gian nghỉ: ${requestDetails.absentDate}") : null;
  requestDetails.tuyen != null ? requestText.writeln("Tuyến đăng ký: ${requestDetails.tuyen}") : null;
  requestDetails.mottuyen != null ? requestText.writeln("Tuyến số: ${requestDetails.mottuyen}") : null;
  requestDetails.studentAddress != null ? requestText.writeln("Địa chỉ: ${requestDetails.studentAddress}") : null;
  requestDetails.name != null ? requestText.writeln("Đơn nguyên: ${requestDetails.name}") : null;
  requestDetails.rentDate != null ? requestText.writeln("Thời gian thuê: ${requestDetails.rentDate}") : null;
  requestDetails.doituonguutien != null ? requestText.writeln("Đối tượng ưu tiên: ${requestDetails.doituonguutien}") : null;
  requestDetails.permanentAddress != null ? requestText.writeln("Địa chỉ thường trú: ${requestDetails.permanentAddress}") : null;
  requestDetails.phoneContact != null ? requestText.writeln("SĐT: ${requestDetails.phoneContact}") : null;
  requestDetails.receivingPlace != null ? requestText.writeln("Nơi nộp đơn và nhận thẻ: ${requestDetails.receivingPlace}") : null;
  requestDetails.email != null ? requestText.writeln("Email: ${requestDetails.email}") : null;
  requestDetails.khicanbaotin != null ? requestText.writeln("Khi cần liên hệ: ${requestDetails.khicanbaotin}") : null;
  (requestDetails.quantityViet != null && requestDetails.quantityViet != "0") ? requestText.writeln("Số bản tiếng Việt: ${requestDetails.quantityViet}") : null;
  (requestDetails.quantityEng != null && requestDetails.quantityEng != "0") ? requestText.writeln("Số bản tiếng Anh: ${requestDetails.quantityEng}") : null;
  requestDetails.reason != null ? requestText.writeln("Lý do: ${requestDetails.reason}") : null;
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