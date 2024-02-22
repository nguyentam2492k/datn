// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:datn/model/request/request_information_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:datn/model/login_model.dart';

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
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async{
    Uri url = Uri(
      scheme: 'https',
      host: 'dummyjson.com',
      path: '/auth/login',
      // https://dummyjson.com/auth/login
    );
    final response = await http.post(url, body: loginRequestModel.toJson());
    if(response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(response.body);
    } else {
      return LoginResponseModel(message: "Unknown Error!");
    }
  }

  Future<List<MyData>> getData() async {
    List<MyData> listData = List.empty();

    Uri url = Uri.parse("http://192.168.1.6:3000/user");

    try {
      var response = await http.get(url);

      if (response.body.isNotEmpty) {
        var data = jsonDecode(response.body) as List;

        // debugPrint("Data: $data");

        listData = data.map((jsonData) => MyData.fromJson(jsonData)).toList();
        return listData;
      }
    } catch (e) {
      debugPrint("GET DATA ERROR: ${e.toString()}");
    }
    return [];
  }

  Future<void> postData(MyData data) async {
    Uri url = Uri.parse("http://192.168.1.6:3000/user");
    
    //WITHOUT FILE
    print("POST START");
    try {
      final response = await http.post(
        url, 
        body: jsonEncode(data.toJson()),
        headers: <String, String>{ 
          'Content-Type': 'application/json; charset=UTF-8', 
        }, 
      );
      if(response.statusCode == 201) {
        print("POST COMPLETED");
      } else {
        throw Exception("FAIL TO POST DATA");
      }
    } catch (e) {
      debugPrint("POST ERROR: ${e.toString()}");
    }

    //POST data with FILE but json-server just accept json-data but not accept form-data
    // var request = http.MultipartRequest('POST', url);

    // Map<String,String> headers={
    //   'Content-Type': 'multipart/form-data; charset=UTF-8', 
    // };

    // request.headers.addAll(headers);

    // request.fields["id"] = data.id;
    // request.fields["userId"] = data.userId;
    // request.fields["title"] = data.title;
    // request.fields["body"] = data.body;

    // request.files.add(http.MultipartFile.fromBytes("file", File(data.file!.path).readAsBytesSync(), filename: (data.file!.path.split("/").last)));

    // try {
    //   var response = await request.send();
    //   if(response.statusCode == 201) {
    //     print("POST COMPLETED");
    //   } else {
    //     throw Exception("FAIL TO POST DATA");
    //   }
    // } catch (e) {
    //   debugPrint("POST ERROR: ${e.toString()}");
    // }
  }

  Future<List<RequestInformation>> getDataTest() async {
    List<RequestInformation> listData = List.empty();

    Uri url = Uri.parse("http://192.168.1.6:3000/requests");

    var response = await http.get(
      url,
      headers: <String, String>{ 
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json;charset=UTF-8'
      }, 
    );

    var responseBody = utf8.decode(response.bodyBytes);

    // print(responseBody);

    if (responseBody.isNotEmpty) {
      var data = jsonDecode(responseBody) as List;

      // debugPrint("Data Length: ${data.length}");

      listData = data.map((jsonData) {
        return RequestInformation.fromJson(jsonData);
      }).toList();
      return listData;
    }
    return [];
  }
}