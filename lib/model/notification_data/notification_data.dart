// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:datn/function/function.dart';
import 'package:datn/model/request/request_model.dart';

class GetListNotificationResponseModel {
  int totalNotification;
  List<NotificationData> listNotification;
  
  GetListNotificationResponseModel({
    required this.totalNotification,
    required this.listNotification,
  });
}

class NotificationData {
  int? id;
  Request? request;
  String? newStatus;
  String? oldStatus;
  int? newStatusId;
  int? oldStatusId;
  DateTime? modifiedDate;
  String? timePassed;

  NotificationData({
    this.id,
    this.request,
    this.newStatus,
    this.oldStatus,
    this.newStatusId,
    this.oldStatusId,
    this.modifiedDate,
    this.timePassed
  });

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    Request? requestData;
    String? myNewStatus;
    String? myOldStatus;
    int? myNewStatusId;
    int? myOldStatusId;

    var request = map['request'];

    if (request is String?) {
      if (request != null) {
        requestData = Request.fromJson(jsonDecode(request));
        myOldStatus = map['oldStatus'] as String?;
        myNewStatus = map['newStatus'] as String?;
      }
    } else {
      requestData = Request.fromJson(request);
      myOldStatus = map['oldStatus']['name'] as String?;
      myNewStatus = map['newStatus']['name'] as String?;
      myNewStatusId = map['newStatus']['id'] as int?;
      myOldStatusId = map['oldStatus']['id'] as int?;
    }

    final localModifiedDate = getDateFromString(map['modified_date'] as String?);

    return NotificationData(
      id: map['id'] as int?,
      request: requestData,
      newStatus: myNewStatus,
      oldStatus: myOldStatus,
      newStatusId: myNewStatusId,
      oldStatusId: myOldStatusId,
      modifiedDate: localModifiedDate,
      timePassed: getTimePassed(localModifiedDate)
    );
  }
}
