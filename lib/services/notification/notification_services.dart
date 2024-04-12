import 'dart:convert';
import 'dart:math';

import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/screens/request_information/request_information_page.dart';
import 'package:datn/services/permission/permission_check.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static final firebaseMessagingInstance = FirebaseMessaging.instance;

  static Future initNotification() async {
    if (await AppPermission.requestNotificationPermission()) {
      await initFirebaseNotification();
      await initLocalNotification();
    }
  }

  static Future initFirebaseNotification() async {
    if (await AppPermission.requestNotificationPermission()) {

      final apnsToken = await firebaseMessagingInstance.getAPNSToken();
      if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
      }
      final fcmToken = await firebaseMessagingInstance.getToken();
      debugPrint("FCM Device Token: $fcmToken");
    } else {
      MyToast.showToast(
        isError: true,
        errorText: "Chưa cấp quyền thông báo"
      );
    }
    debugPrint("init firebase msg");
  }

  static subscribeToTopic(String topicName) async {
    await firebaseMessagingInstance.subscribeToTopic(topicName);
    print("SUBSCRIBED TO TOPIC $topicName");
  }

  static unsubscribeFromTopic(String topicName) async {
    await firebaseMessagingInstance.unsubscribeFromTopic(topicName);
    print("UNSUBSCRIBED FROM TOPIC $topicName");
  }

  @pragma('vm:entry-point')
  static Future<void> doSomethingWithMessage(RemoteMessage message) async {
    // if (message.notification != null) {
    //   debugPrint("Notification message: ${message.data}");
    // } else {
    //   debugPrint("NO NOTIFICATION");
    // }
  }


  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "request_notification", 
    "Status Changed Notification",
    description: "This is for notification for request's status changed",
    importance: Importance.max,
  );

  static Future initLocalNotification() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );
    debugPrint("init local noti");
  }

  // on tap local notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    var payload = notificationResponse.payload;
    if (payload != null) {
      globalNavigatorKey.currentState!.push(MaterialPageRoute(builder: (context) {
        var messageData = jsonDecode(payload);
        var requestData = jsonDecode(messageData['request']);
        return RequestInformationPage(requestInfo: Request.fromJson(requestData));
      },));
    }
  }

  // show a simple local notification
  static Future showSimpleNotification({
    required RemoteMessage message,
  }) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id, 
      channel.name,
      channelDescription: channel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    flutterLocalNotificationsPlugin
        .show(Random().nextInt(99), message.notification?.title, message.notification?.body, notificationDetails, payload: jsonEncode(message.data));
  }
  
}
