import 'dart:convert';
import 'dart:math';

import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/notification_data/notification_data.dart';
import 'package:datn/screens/request_information/request_information_page.dart';
import 'package:datn/services/permission/permission_check.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {

  static final firebaseMessagingInstance = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "request_notification", 
    "Status Changed Notification",
    description: "This is for notification for request's status changed",
    importance: Importance.max,
  );


  static Future initNotification() async {
    if (await AppPermission.requestNotificationPermission()) {
      await initFirebaseNotification();
      await initLocalNotification();
      NotificationServices.subscribeToTopic(getGlobalLoginResponse().id ?? "");
    }
  }

  static Future initFirebaseNotification() async {
    if (await AppPermission.requestNotificationPermission()) {

      final apnsToken = await firebaseMessagingInstance.getAPNSToken();
      if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
      }
      final fcmToken = await firebaseMessagingInstance.getToken();
      print("FCM Device Token: $fcmToken");
    } else {
      MyToast.showToast(
        isError: true,
        errorText: "Chưa cấp quyền thông báo"
      );
    }
    print("init firebase msg");
  }

  static Future initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_stat_uet');
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onSelectForegroundNotification,
    );
    print("init local noti");
  }

  static subscribeToTopic(String topicName) async {
    await firebaseMessagingInstance.subscribeToTopic(topicName);
  }

  static unsubscribeFromTopic(String topicName) async {
    await firebaseMessagingInstance.unsubscribeFromTopic(topicName);
  }

  @pragma('vm:entry-point')
  static Future<void> doSomethingWithMessage(RemoteMessage message) async {
    // if (message.notification != null) {
    //   print("Notification message: ${message.data}");
    // } else {
    //   print("NO NOTIFICATION");
    // }
  }

  static Future<void> showForegroundNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationServices.showLocalNotification(message: message);
    });
  }

  // show local notification
  static Future showLocalNotification({
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

  // on tap firebase/background notification
  static Future<void> onSelectBackgroundNotification() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

    if (message?.notification != null) {
      handleTapNotification(messageData: message!.data);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      handleTapNotification(messageData: message.data);
    });
  }

  // on tap local notification in foreground
  static void onSelectForegroundNotification(NotificationResponse notificationResponse) {
    var payload = notificationResponse.payload;
    if (payload != null) {
      var messageData = jsonDecode(payload);
      handleTapNotification(messageData: messageData);
    }
  }

  static void handleTapNotification({required Map<String, dynamic> messageData}) {
    if (isRequestInformationPageOpened) {
      globalNavigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) {
        var notificationData = NotificationData.fromMap(messageData);
        return RequestInformationPage(requestInfo: notificationData.request!,);
      },));
    } else {
      globalNavigatorKey.currentState?.push(MaterialPageRoute(builder: (context) {
        var notificationData = NotificationData.fromMap(messageData);
        return RequestInformationPage(requestInfo: notificationData.request!,);
      },));
    }
  }
  
}
