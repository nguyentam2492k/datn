import 'dart:io';

import 'package:datn/model/request/file_data_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

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
            await getFileUrl(child: child, filename: platformFile.name)
              .then((value) {
                listFile.add(FileData(filename: platformFile.name, url: value));
              });
          });
      } catch (e) {
        listFile.clear();
        return ;
      }
    
    }));
    return listFile;
  }

  Future<void> uploadFileToFirebaseStorage({required File fileUpload, required String child, required String filename}) async {
    print("Start Upload");
    final contentType = lookupMimeType(fileUpload.path);
    final metadata = SettableMetadata(contentType: contentType);
    try {
      final uploadTask = await storageRef
        .child("$child/$filename")
        .putFile(fileUpload, metadata);

      switch (uploadTask.state) {
        case TaskState.error:
          throw "Upload Error";
        default:
      }
    } catch (e) {
      rethrow;
    }
    print("Upload End");
  }

}