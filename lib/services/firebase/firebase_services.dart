import 'dart:io';

import 'package:datn/model/request/file_data_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseServices {

  //TODO: FIREBASE STORAGE
  final storageRef = FirebaseStorage.instance.ref();

  Future<List<Reference>> getListFileRef() async {
    ListResult result = await storageRef.child("files").listAll();

    return result.items;
  } 

  Future<String> getFileUrl({required String child, required String filename}) async {
    final ref = storageRef.child("$child/$filename");
    var fileDownloadUrl = await ref.getDownloadURL();
    return fileDownloadUrl;
  }

  Future<List<FileData>> uploadMultipleFile({required String child, required List<PlatformFile> files}) async {
    
    List<FileData> listFile = [];

    await Future.wait(files.map((platformFile) async {
      var file = File(platformFile.path!);

      try {
        await uploadFileToFirebaseStorage(fileUpload: file, child: child, filename: platformFile.name)
          .then((value) async {
            print("MESSAGE - $value");
            if (value != null) {
              listFile.clear();
              return;
            }
            await getFileUrl(child: child, filename: platformFile.name)
              .then((value) {
                listFile.add(FileData(filename: platformFile.name, url: value));
              });
          });
      } catch (e) {
        listFile.clear();
      }
    
    })).then((value) {
      return listFile;
    });
    return listFile;
  }

  Future<String?> uploadFileToFirebaseStorage({required File fileUpload, required String child, required String filename}) async {
    print("Start Upload");
    try {
      final uploadTask = await storageRef
        .child("$child/$filename")
        .putFile(fileUpload);

      switch (uploadTask.state) {
        case TaskState.error:
          throw "Upload Error";
        default:
      }
    } catch (e) {
      rethrow;
      // return "ERROR: ${e.toString()}";
    }
    print("Upload End");
    return null;
  }

  //TODO: OPEN FILE FROM FIREBASE
  // Future<void> openFileFirebase(String folder, String filename) async {
  //   final fileRef = storageRef.child("$folder/$filename");
  //   final tempDir = await getTemporaryDirectory();
  //   File file = await File('${tempDir.path}/$filename').create();

  //   final downloadTask = fileRef.writeToFile(file);
  //   downloadTask.snapshotEvents.listen((taskSnapshot) async {
  //     switch (taskSnapshot.state) {

  //       case TaskState.success:
  //         OpenResult result;
  //         try {
  //           result = await OpenFile.open(
  //             file.path,
  //           );

  //           // setState(() {
  //             debugPrint("type=${result.type} message=${result.message}");
  //           // });
  //         } catch (error) {
  //           debugPrint(error.toString());
  //         }
  //         break;
  //       case TaskState.error:
  //         throw(TaskState.error);
  //       default:
  //     }
  //   });
  // }
}