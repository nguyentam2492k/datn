import 'dart:io';

import 'package:datn/function/function.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:datn/widgets/manage_request/file_alert_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
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
          print(result.message);
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

  Future<bool> checkStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;

    bool permissionStatus;

    if (android.version.sdkInt >= 33) {
      final externalStorageStatus = await Permission.manageExternalStorage.request();
      final photoStorageStatus = await Permission.photos.request();
      final videoStorageStatus = await Permission.videos.request();

      permissionStatus =  (externalStorageStatus == PermissionStatus.granted
              && photoStorageStatus == PermissionStatus.granted
              && videoStorageStatus == PermissionStatus.granted);

    } else if (android.version.sdkInt >= 30 && android.version.sdkInt < 33) {
      final externalStorageStatus = await Permission.manageExternalStorage.request();
      final storageStatus = await Permission.storage.request();
      permissionStatus = externalStorageStatus == PermissionStatus.granted && storageStatus == PermissionStatus.granted;
    } else {
      final storageStatus = await Permission.storage.request();
      permissionStatus = storageStatus == PermissionStatus.granted;
    }

    if (!permissionStatus) {
      openAppSettings();
    }

    return permissionStatus;
  }

  downloadFileFromUrl(BuildContext buildContext, {required String url}) async {

    var permissionReady = await checkStoragePermission();

    if (permissionReady) {
      await FileDownloader.downloadFile(
        url: url,
        name: getFileNameFromUrl(url),
        onDownloadError: (errorMessage) {
          CustomSnackBar().showSnackBar(
            buildContext,
            isError: true,
            errorText: "LỖI: $errorMessage",
          );
        },
        onDownloadCompleted: (path) async {
          showDialog(
            context: buildContext, 
            builder: (context) {
              return fileAlertDialog(parentContext: buildContext, alertContext: context, url: url, path: Uri.decodeComponent(path));
            },
          );
        },
      );  
    } 
  }
}