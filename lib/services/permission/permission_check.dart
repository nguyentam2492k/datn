import 'dart:io';

import 'package:datn/global_variable/globals.dart';
import 'package:datn/services/notification/notification_services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static Future<bool> checkStoragePermission(BuildContext context) async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();

    bool permissionStatus;

    if (Platform.isAndroid) {
      AndroidDeviceInfo android = await plugin.androidInfo;
      if (android.version.sdkInt >= 33) {
        final photoStatus = await Permission.photos.request();
        final videoStatus = await Permission.videos.request();
        final audioStatus = await Permission.audio.request();

        permissionStatus = photoStatus == PermissionStatus.granted
                          && videoStatus == PermissionStatus.granted
                          && audioStatus == PermissionStatus.granted;
      } else {
        final storageStatus = await Permission.storage.request();
        permissionStatus = (storageStatus == PermissionStatus.granted);
      }
    } else {
      final storageStatus = await Permission.storage.request();
      permissionStatus = storageStatus == PermissionStatus.granted;
    }

    if (!permissionStatus && context.mounted) {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))
            ),
            titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            actionsPadding: const EdgeInsets.all(5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            title: const Text("Yêu cầu", style: TextStyle(fontWeight: FontWeight.bold),),
            content: const Text("Để tải và mở file, vui lòng cho phép ứng dụng quyền quản lý tất cả tệp trên thiết bị"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: const Text("Đóng")
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                }, 
                child: const Text("Mở Cài đặt")
              )
            ],
          );
        }
      );
    }

    return permissionStatus;
  }

  static Future<bool> requestNotificationPermission() async {
    final notificationSettings = await NotificationServices.firebaseMessagingInstance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
      showDialog(
        context: globalNavigatorKey.currentContext!, 
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))
            ),
            titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            actionsPadding: const EdgeInsets.all(5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            title: const Text("Yêu cầu", style: TextStyle(fontWeight: FontWeight.bold),),
            content: const Text("Để nhận thông báo về trạng thái của yêu cầu, vui lòng cấp quyền thông báo cho úng dụng"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: const Text("Đóng")
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                }, 
                child: const Text("Mở Cài đặt")
              )
            ],
          );
        }
      );
    }

    return notificationSettings.authorizationStatus == AuthorizationStatus.authorized;
  }
}