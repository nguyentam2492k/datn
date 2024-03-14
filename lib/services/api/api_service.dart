import 'dart:convert';

import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/firebase/firebase_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:datn/model/login_model.dart';
import 'package:uuid/v1.dart';

class MyData {
  String id;
  String userId;
  String title;
  String body;
  String? file;

  MyData({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.file
  });

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      file: json['file'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title':  title.trim(),
      'body': body.trim(),
      'file': file
    };
  }

  @override
  String toString() {
    return 'MyData(id: $id, userId: $userId, title: $title, body: $body)';
  }
}

class APIService {

  static const host = "http://192.168.1.5:3000";
  static const myHost = "https://uet-student-cc10e59e8dec.herokuapp.com";

  // Future<dynamic> login(LoginRequestModel loginRequestModel) async{
  //   Uri url = Uri.parse("http://$host:3000/login");
    
  //   try {
  //     final response = await http.post(url, body: loginRequestModel.toJson());
  //     // print(response.body);
  //     if(response.statusCode == 200) {
  //       return LoginResponseModel.fromJson(jsonDecode(response.body));
  //     } else {
  //       // print("Unknown Error!");
  //       return response.body;
  //     }
  //   } catch (e) {
  //     return (e.toString());
  //   }
  // }

  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async{
    Uri url = Uri.parse("$myHost/api/v1/login");
    
    try {
      final response = await http.post(url, body: loginRequestModel.toJson());
      if(response.statusCode == 200 || response.statusCode == 401) {
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> logout() async {
    Uri url = Uri.parse("$myHost/api/v1/logout");

    try {
      final response = await http.post(
        url, 
        body: null,
        headers: <String, String>{ 
          'Authorization': 'Bearer ${globalLoginResponse!.accessToken}'
        }, 
      );
      if(response.statusCode == 200) {
        var body = jsonDecode(response.body) as Map<String, dynamic>;
        return body['message'] as String;
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Request>> getData(String? status, int startIndex, String userId, {int limit = 10}) async {
    List<Request> listData = [];

    String currentStatus;
    String baseUrl = "$host/requests?_sort=id&_order=desc&userId=$userId&_start=$startIndex&_limit=$limit";
    Uri url = Uri();

    switch (status) {
      case "Đã xong":
        currentStatus = "&status=completed";
      case "Đã huỷ":
        currentStatus = "&status=canceled";
      case "Đang xử lý":
        currentStatus = "&status=processing";
      default:
        currentStatus = "";
    }
    url = Uri.parse("$baseUrl$currentStatus");
    print(url);

    try {
      var response = await http.get(
        url,
        headers: <String, String>{ 
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer ${globalLoginResponse!.accessToken}'
        }, 
      );

      if (response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);

        if (responseBody.isNotEmpty) {
          var data = jsonDecode(responseBody) as List;
          listData = data.map((jsonData) {
            return Request.fromJson(jsonData);
          }).toList();
          return listData;
        }
      } else {
        return [];
      }
    } on Exception catch (e) {
      print("GET DATA ERROR: ${e.toString()}");
      rethrow;
    }
    return [];
  }

  Future<String?> postData({required Request request, required Map<String, dynamic> requestInfo}) async {
    Uri url = Uri.parse("$host/requests");

    var bodyMap = request.toMap();
    bodyMap.addAll({"info": requestInfo});
    
    try {
      final response = await http.post(
        url, 
        body: jsonEncode(bodyMap),
        headers: <String, String>{ 
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json;charset=UTF-8',
          'Authorization': 'Bearer ${globalLoginResponse!.accessToken}'
        }, 
      );
      if(response.statusCode == 201) {
        return null;
      } else {
        print(response.reasonPhrase);
        return "#${response.statusCode}: ${response.reasonPhrase}";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
      // rethrow;
    }
  }

  Future<void> postDataWithFile({required Request request, required Map<String, dynamic> formData, required List<PlatformFile> files}) async {
    FirebaseServices firebaseServices = FirebaseServices();

    var uuid = const UuidV1().generate();

    String child = "files/${globalLoginResponse?.user?.id}/$uuid";

    await firebaseServices.uploadMultipleFile(child: child, files: files)
        .then((value) async {          
          if (value.isEmpty) {
            throw "Upload file lỗi";
          }
          var requestSend = request;
          requestSend.file = value;
          await postData(request: requestSend, requestInfo: formData)
            .then((value) {
              if (value != null) {
                firebaseServices.deleteFolder(folderPath: child);
                throw value;
              }
            });
        });
  }

}