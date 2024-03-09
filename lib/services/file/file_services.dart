import 'dart:io';

import 'package:datn/function/function.dart';
import 'package:datn/widgets/custom_widgets/rename_file_alert.dart';
import 'package:datn/widgets/custom_widgets/file_alert_dialog.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileServices {

  Future<void> openFileFromUrl({required BuildContext context, required String url, required String filename}) async {
    var httpClient = HttpClient();

    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/$filename').create();

    await file.writeAsBytes(bytes);

    OpenResult result;
    try {
      result = await OpenFile.open(
        file.path,
      );

      switch (result.type) {
        case ResultType.done:
          break;
        case ResultType.fileNotFound:
          throw "File not found!";
        case ResultType.noAppToOpen:
          throw "No app to open!";
        case ResultType.permissionDenied:
          throw "Permission denied!";
        case ResultType.error:
          throw ResultType.error.name;
      }
    } catch (error) {
      if (context.mounted) {
        CustomSnackBar().showSnackBar(
          context,
          isError: true,
          errorText: "LỖI: ${error.toString()}"
        );
      }
    }
    // return file;
  }

  Future<void> openFileFromPath({required BuildContext context, required String path}) async {
    
    OpenResult result;
    try {
      result = await OpenFile.open(
        path,
      );

      switch (result.type) {
        case ResultType.done:
          break;
        case ResultType.fileNotFound:
          throw "File not found!";
        case ResultType.noAppToOpen:
          throw "No app to open!";
        case ResultType.permissionDenied:
          throw "Permission denied!";
        case ResultType.error:
          throw ResultType.error.name;
      }
    } catch (error) {
      if (context.mounted) {
        CustomSnackBar().showSnackBar(
          context,
          isError: true,
          errorText: "LỖI: ${error.toString()}"
        );
      }
    }
    // return file;
  }

  Future<bool> checkStoragePermission(BuildContext context) async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;

    bool permissionStatus;

    if (android.version.sdkInt >= 33) {
      final photoStorageStatus = await Permission.photos.request();
      final videoStorageStatus = await Permission.videos.request();

      permissionStatus = photoStorageStatus == PermissionStatus.granted
                        && videoStorageStatus == PermissionStatus.granted;
    } else {
      final storageStatus = await Permission.storage.request();
      permissionStatus = (storageStatus == PermissionStatus.granted);
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
      // await checkStoragePermission();
    }

    return permissionStatus;
  }

  Future<String?> downloadAndGetFileFromUrl(BuildContext buildContext, {required String url}) async {

    var permissionReady = await checkStoragePermission(buildContext);

    if (permissionReady) {

      final externalDir = await getExternalStorageDirectory();
      var savePath = "${externalDir!.path}/${getFileNameFromUrl(url)}";

      if (File(savePath).existsSync() && buildContext.mounted) {
        var newFilename = await showDialog(
          barrierDismissible: false,
          context: buildContext, 
          builder: (context) {
            return ChangeFilenameAlertDialog(fullFilename: getFileNameFromUrl(url));
          }
        );
        savePath = "${externalDir.path}/$newFilename";
      }
      
      buildContext.mounted ? buildContext.loaderOverlay.show(progress: "Chuẩn bị tải") : null;
      try {
        var response = await Dio().downloadUri(
          Uri.parse(url), 
          savePath,
          onReceiveProgress: (count, total) {
            buildContext.loaderOverlay.progress("Đang tải: ${(100*count/total).toStringAsFixed(1)}%");
          },
        );
        if (response.statusCode == 200) {
          return savePath;
        }
      } on DioException catch (dioError) {
        throw dioError.message.toString();
      } catch (e) {
        rethrow;
      }
      return null;
    }
    return null;
  }

  Future<void> actionDownloadFileWithUrl(BuildContext context, {required String url}) async {
    try {
      await FileServices().downloadAndGetFileFromUrl(context, url: url)
        .then((path) async {
          context.loaderOverlay.hide();
          if (path == null) {
            CustomSnackBar().showSnackBar(
              context,
              isError: true,
              errorText: "LỖI",
            );
            return;
          }
          showDialog(
            context: context, 
            builder:(context) {
              return CustomAlertDialog(path: Uri.decodeComponent(path),);
            },
          );
        });
    } catch (error) {
      if (context.mounted) {
        context.loaderOverlay.hide();
        CustomSnackBar().showSnackBar(
          context,
          isError: true,
          errorText: "LỖI: $error",
        );
      }
    }
  }
}