import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

class FirebaseServices {

  //TODO: FIREBASE STORAGE REFERENCE
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

  Future<void> deleteFolder({required String folderPath}) async {
    await storageRef.child(folderPath).listAll()
      .then((value) async {
        for (var element in value.items) {
          await FirebaseStorage.instance.ref(element.fullPath).delete().then((value){
            print("Delete completed");
          });
        }
      });
  }

  Future<List<String>> uploadMultipleFile({required String child, required List<PlatformFile> files}) async {
    
    List<String> listFileUrl = [];

    await Future.wait(files.map((platformFile) async {

      var file = File(platformFile.path!);

      try {
        await uploadFileToFirebaseStorage(fileUpload: file, child: child, filename: platformFile.name)
          .then((value) async {
            await getFileUrl(child: child, filename: platformFile.name)
              .then((value) {
                listFileUrl.add(value);
              });
          });
      } catch (e) {
        listFileUrl.clear();
        return ;
      }
    
    }));
    return listFileUrl;
  }

  //TODO: UPLOAD 1 FILE TO FIREBASE STORAGE
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