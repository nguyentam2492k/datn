import 'dart:io';

import 'package:datn/function/function.dart';
import 'package:datn/widgets/custom_widgets/rename_file_alert.dart';
import 'package:datn/widgets/custom_widgets/file_alert_dialog.dart';
import 'package:datn/widgets/custom_widgets/snack_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileServices {

  Future<List<PlatformFile>?> pickFile({required List<PlatformFile> listFiles}) async {
    const maxFileSize = 5 * 1024 * 1024;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
      );
      
      if (result != null) {
        var listFileSize = result.files.map((e) => e.size).toList();
        if (listFileSize.every((size) => size <= maxFileSize)) {
          Set<PlatformFile> fileSet = Set.from(listFiles);
          fileSet.addAll(result.files);
          var files = fileSet.toList();
          for (var file in files) {
            print("${file.name}-${file.size}");
          }
          return files;
        } else {
          throw "Kich thước file >= 5MB";
        }
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

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
      CustomSnackBar().showSnackBar(
        isError: true,
        errorText: "LỖI: ${error.toString()}"
      );
    }
    // return file;
  }

  Future<void> openFileFromPath({required BuildContext context, required String? path}) async {
    if (path == null) {
      CustomSnackBar().showSnackBar(
        isError: true,
        errorText: "LỖI: File's Path is Null"
      );
      return;
    }
    
    var permissionReady = await checkStoragePermission(context);

    if (permissionReady) {
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
        CustomSnackBar().showSnackBar(
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
    var loaderOverlay = buildContext.loaderOverlay;
    var permissionReady = await checkStoragePermission(buildContext);

    if (permissionReady) {

      final externalDir = await getExternalStorageDirectory();
      final fullFilename = getFileNameFromUrl(url);
      var savePath = "${externalDir!.path}/$fullFilename";

      if (File(savePath).existsSync() && buildContext.mounted) {
        var newFilename = await showDialog(
          barrierDismissible: false,
          context: buildContext, 
          builder: (context) {
            return ChangeFilenameAlertDialog(fullFilename: fullFilename);
          }
        );
        if (newFilename == null) {
          return "cancel";
        }
        savePath = "${externalDir.path}/${newFilename ?? fullFilename}";
      }
      
      loaderOverlay.show(progress: "Chuẩn bị tải");
      try {
        var response = await Dio().downloadUri(
          Uri.parse(url), 
          savePath,
          onReceiveProgress: (count, total) {
            loaderOverlay.progress("Đang tải: ${(100*count/total).toStringAsFixed(1)}%");
          },
        );
        loaderOverlay.hide();
        if (response.statusCode == 200) {
          return savePath;
        } else {
          throw response.statusMessage.toString();
        }
      } on DioException catch (dioError) {
        throw dioError.message.toString();
      } catch (e) {
        rethrow;
      }
    }
    return null;
  }

  Future<void> actionDownloadFileWithUrl(BuildContext context, {required String url}) async {
    try {
      await FileServices().downloadAndGetFileFromUrl(context, url: url)
        .then((path) async {
          if (path == null) {
            CustomSnackBar().showSnackBar(
              isError: true,
              errorText: "LỖI",
            );
            return;
          }
          if (path == "cancel") {
            return;
          }
          showDialog(
            context: context, 
            builder:(context) {
              return FileAlertDialog(path: Uri.decodeComponent(path),);
            },
          );
        });
    } catch (error) {
      CustomSnackBar().showSnackBar(
        isError: true,
        errorText: "LỖI: $error",
      );
    }
  }
}