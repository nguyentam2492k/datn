import 'dart:io';

import 'package:datn/constants/my_icons.dart';
import 'package:datn/model/request/request_information_model.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';

String? formatDateWithTime(String? dateWithTime, {bool outputIncludeTime = false}) {
  if (dateWithTime == null) {
    return null;
  }

  var inputFormat = DateFormat('yyyy-MM-dd hh:mm');
  DateTime inputDate;

  try {
    inputDate = inputFormat.parse(dateWithTime);
  } catch (e) {
    return dateWithTime;
  }
  
  var outputFormat = DateFormat();
  if (outputIncludeTime) {
    outputFormat = DateFormat('dd/MM/yyyy HH:mm');
  } else {
    outputFormat = DateFormat('dd/MM/yyyy');
  }
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

DateTime? getDateFromString(String? dateString) {
  if (dateString == null) {
    return null;
  }

  var dateFormat = DateFormat('yyyy-MM-dd hh:mm');
  DateTime dateTime;

  try {
    dateTime = dateFormat.parse(dateString);
  } catch (e) {
    return null;
  }

  return dateTime;
}

DateTime addDateToDateTime(DateTime date, int numberOfDateAdd) {
  var newDate = date.add(Duration(days: numberOfDateAdd));
  return newDate;
}

bool isInteger(String? s) {
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}

Color getColor(int statusId) {
  switch (statusId) {
    case 2: //Đã xong
      return Colors.green;
    case 3: //Đã huỷ
      return Colors.red;
    case 1: //Đang xử lý
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
  if (list.isEmpty) {
    return [];
  }
  var listString =  list.map((item) {
    if (item.runtimeType == int) {
      return "Học kỳ $item";
    } else {
      return item as String;
    }
  }).toList();
  listString.sort();
  return listString;
}

String getRequestText(RequestInformation requestInfo) {
  var requestText = StringBuffer();
  requestInfo.certificateType != null ? requestText.writeln("Loại GCN: ${requestInfo.certificateType}") : null;
  requestInfo.semesterType != null ? requestText.writeln("Loại kỳ: ${requestInfo.semesterType}") : null;
  (requestInfo.semesterNumber != null && requestInfo.semesterNumber!.isNotEmpty) ? requestText.writeln("Kỳ: ${listToString(requestInfo.semesterNumber!)}") : null;
  requestInfo.transcriptType != null ? requestText.writeln("Loại bảng điểm: ${requestInfo.transcriptType}") : null;
  requestInfo.subject != null ? requestText.writeln("Môn học: ${requestInfo.subject}") : null;
  requestInfo.lecturer != null ? requestText.writeln("Giảng viên: ${requestInfo.lecturer}") : null;
  requestInfo.examDate != null ? requestText.writeln("Ngày thi: ${requestInfo.examDate}") : null;
  requestInfo.subjectReview != null ? requestText.writeln("Học phần: ${requestInfo.subjectReview}") : null;
  requestInfo.semester != null ? requestText.writeln("Học kỳ: ${requestInfo.semester}") : null;
  requestInfo.programType != null ? requestText.writeln("Chương trình đào tạo: ${requestInfo.programType}") : null;
  requestInfo.year != null ? requestText.writeln("Năm học: ${requestInfo.year}") : null;
  (requestInfo.documents != null && requestInfo.documents!.isNotEmpty) ? requestText.writeln("Hồ sơ mượn: ${listToString(requestInfo.documents!)}") : null;
  requestInfo.otherDocument != null ? requestText.writeln("Hồ sơ khác: ${requestInfo.otherDocument}") : null;
  requestInfo.monthFee != null ? requestText.writeln("Học phí theo tháng (VNĐ): ${requestInfo.monthFee}") : null;
  requestInfo.tuyen != null ? requestText.writeln("Tuyến đăng ký: ${requestInfo.tuyen}") : null;
  requestInfo.mottuyen != null ? requestText.writeln("Một tuyến số: ${requestInfo.mottuyen}") : null;
  requestInfo.name != null ? requestText.writeln("Đơn nguyên: ${requestInfo.name}") : null;
  requestInfo.studentAddress != null ? requestText.writeln("Địa chỉ: ${requestInfo.studentAddress}") : null;
  requestInfo.startDate != null ? requestText.writeln("Từ ngày: ${requestInfo.startDate}") : null;
  requestInfo.endDate != null ? requestText.writeln("Đến ngày: ${requestInfo.endDate}") : null;
  requestInfo.doituonguutien != null ? requestText.writeln("Đối tượng ưu tiên: ${requestInfo.doituonguutien}") : null;
  requestInfo.phoneContact != null ? requestText.writeln("SĐT: ${requestInfo.phoneContact}") : null;
  requestInfo.receivingPlace != null ? requestText.writeln("Nơi nộp đơn và nhận thẻ: ${requestInfo.receivingPlace}") : null;
  requestInfo.email != null ? requestText.writeln("Email: ${requestInfo.email}") : null;
  requestInfo.khicanbaotin != null ? requestText.writeln("Khi cần liên hệ: ${requestInfo.khicanbaotin}") : null;
  requestInfo.learningProgram != null ? requestText.writeln("Chương trình đào tạo: ${requestInfo.learningProgram}") : null;
  requestInfo.internCompany != null ? requestText.writeln("Nơi thực tập: ${requestInfo.internCompany}") : null;
  (requestInfo.quantityViet != null && requestInfo.quantityViet != 0) ? requestText.writeln("Số bản tiếng Việt: ${requestInfo.quantityViet}") : null;
  (requestInfo.quantityEng != null && requestInfo.quantityEng != 0) ? requestText.writeln("Số bản tiếng Anh: ${requestInfo.quantityEng}") : null;
  requestInfo.reason != null ? requestText.writeln("Lý do: ${requestInfo.reason}") : null;
  return requestText.toString().trim();
}

String getStatus(int statusId) {
  switch (statusId) {
    case 1:
      return "Đang xử lý";
    case 2:
      return "Đã xong";
    case 3:
      return "Đã huỷ";
    default:
      return "----";
  }
}

IconData getIcon(String fileName) {
  final mimeType = lookupMimeType(fileName);
  if (mimeType == null) {
    return MyIcons.document;
  }
  if (mimeType.startsWith("image/")) {
    return MyIcons.image;
  }
  if (mimeType.endsWith("/pdf")) {
    return MyIcons.pdf;
  }
  if (mimeType.startsWith("video/")) {
    return MyIcons.video;
  }
  if (mimeType.startsWith("audio/")) {
    return MyIcons.audio;
  }
  return MyIcons.document;
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

Future<void> openUrl(BuildContext context, {required String urlString}) async {
    var uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)){
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault
        );
    } else {
      MyToast.showToast(
        isError: true,
        errorText: "LỖI",
      );
    }
  }