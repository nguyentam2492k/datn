import 'dart:convert';

import 'package:datn/model/request/request_model.dart';

class NotificationData {
  Request? request;
  String? newStatus;
  String? oldStatus;

  NotificationData({
    this.request,
    this.newStatus,
    this.oldStatus,
  });

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    String? requestDataString = map['request'] as String?;
    Request? requestData;

    if (requestDataString != null) {
      requestData = Request.fromJson(jsonDecode(requestDataString));
    }

    return NotificationData(
      request: requestData,
      newStatus: map['newStatus'] != null ? map['newStatus'] as String : null,
      oldStatus: map['oldStatus'] != null ? map['oldStatus'] as String : null,
    );
  }
}
