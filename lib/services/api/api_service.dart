import 'dart:convert';

import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/request/request_model.dart';
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

  static const host = "192.168.1.5";

  Future<dynamic> login(LoginRequestModel loginRequestModel) async{
    Uri url = Uri.parse("http://$host:3000/login");
    
    try {
      final response = await http.post(url, body: loginRequestModel.toJson());
      // print(response.body);
      if(response.statusCode == 200) {
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      } else {
        // print("Unknown Error!");
        return response.body;
      }
    } catch (e) {
      return (e.toString());
    }
  }

  Future<List<Request>> getData(String? status, int startIndex, String userId, {int limit = 10}) async {
    List<Request> listData = [];

    String currentStatus;
    String baseUrl = "http://$host:3000/requests?_sort=id&_order=desc&userId=$userId&_start=$startIndex&_limit=$limit";
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
      debugPrint("GET DATA ERROR: ${e.toString()}");
      rethrow;
    }
    return [];
  }

  Future<String?> postData({required Request request, required Map<String, dynamic> requestInfo}) async {
    Uri url = Uri.parse("http://$host:3000/requests");

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
      // return "Other Error";
      return e.toString();
      // rethrow;
    }
  }

}