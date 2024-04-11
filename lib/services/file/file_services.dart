import 'dart:io';

import 'package:datn/function/function.dart';
import 'package:datn/services/handle/my_handle.dart';
import 'package:datn/services/permission/permission_check.dart';
import 'package:datn/widgets/custom_widgets/rename_file_alert.dart';
import 'package:datn/widgets/custom_widgets/file_alert_dialog.dart';
import 'package:datn/widgets/custom_widgets/my_toast.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileServices {

  Future<List<PlatformFile>?> pickFile(BuildContext context, {bool isPickImage = false, bool allowMultiple = true, required List<PlatformFile> listFiles}) async {
    const maxFileSize = 5 * 1024 * 1024;
    var permissionReady = await AppPermission.checkStoragePermission(context);

    if (permissionReady) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: allowMultiple,
          type: isPickImage ? FileType.image : FileType.any
        );
        
        if (result != null) {
          var listFileSize = result.files.map((e) => e.size).toList();
          if (listFileSize.every((size) => size <= maxFileSize)) {
            if (!allowMultiple) {
              return result.files;
            } else {
              Set<PlatformFile> fileSet = Set.from(listFiles);
              fileSet.addAll(result.files);
              var files = fileSet.toList();
              return files;
            }
          } else {
            throw "Kich thước file >= 5MB";
          }
        } else {
          return null;
        }
      } catch (error) {
        rethrow;
      }
    } else {
      throw "Chưa cấp quyền";
    }
  }

  Future<void> openFileFromUrl({required String url, required String filename}) async {
    var httpClient = HttpClient();

    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/$filename').create();

    await file.writeAsBytes(bytes);

    OpenResult result;
    try {
      result = await OpenFilex.open(
        file.path,
      );

      final resultType = MyHandle.handleOpenFileResult(result.type);
      if (resultType != null) {
        throw resultType;
      }
    } catch (error) {
      MyToast.showToast(
        isError: true,
        errorText: "LỖI: ${error.toString()}"
      );
    }
  }

  Future<void> openFileFromPath({required BuildContext context, required String? path}) async {
    if (path == null) {
      MyToast.showToast(
        isError: true,
        errorText: "LỖI: File's Path is Null"
      );
      return;
    }
    
    var permissionReady = await AppPermission.checkStoragePermission(context);

    if (permissionReady) {
      OpenResult result;
      try {
        result = await OpenFilex.open(
          path,
        );

        final resultType = MyHandle.handleOpenFileResult(result.type);
        if (resultType != null) {
          throw resultType;
        }
      } catch (error) {
        MyToast.showToast(
          isError: true,
          errorText: "LỖI: ${error.toString()}"
        );
      }
    }
  }

  Future<String> downloadAndGetFileFromUrl(BuildContext buildContext, {required String url}) async {
    var permissionReady = await AppPermission.checkStoragePermission(buildContext);

    if (permissionReady) {
      final externalDir = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory(); //FOR IOS

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
          return "cancel_rename";
        }
        savePath = "${externalDir.path}/${newFilename ?? fullFilename}";
      }
      
      await EasyLoading.show();
      try {
        var response = await Dio().download(
          url, 
          savePath,
          onReceiveProgress: (count, total) async {
            if (total > 0) {
              await EasyLoading.showProgress(count/total, status: "Đang tải: ${(100 * count/total).toStringAsFixed(0)}%");
            }
          },
        );
        await EasyLoading.dismiss();
        if (response.statusCode == 200) {
          return savePath;
        } else {
          throw response.statusMessage.toString();
        }
      } on DioException catch (dioError) {
        await EasyLoading.dismiss();
        throw MyHandle.handleDioError(dioError.type);
      } catch (e) {
        await EasyLoading.dismiss();
        rethrow;
      }
    } else {
      throw "Chưa cấp quyền";
    }
  }

  Future<void> actionDownloadFileWithUrl(BuildContext context, {required String url}) async {
    try {
      await FileServices().downloadAndGetFileFromUrl(context, url: url)
        .then((path) async {
          if (path == "cancel_rename") {
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
      MyToast.showToast(
        isError: true,
        errorText: "LỖI: $error",
      );
    }
  }
}