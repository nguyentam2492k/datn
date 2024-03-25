import 'dart:convert';
import 'dart:io';

import 'package:datn/model/enum/request_type.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/login/login_model.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/handle/my_handle.dart';

class APIService {

  static const host = "https://uet-student-cc10e59e8dec.herokuapp.com/api/v1";

  final dio = Dio();

  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async{
    Uri url = Uri.parse("$host/login");
    
    try {
      final response = await dio.postUri(
        url, 
        data: loginRequestModel.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept' : 'application/json; charset=UTF-8'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
          responseType: ResponseType.plain
        ),
      );
      if(response.statusCode == 200 || response.statusCode == 401) {
        return LoginResponseModel.fromJson(jsonDecode(response.data));
      } else {
        throw response.statusMessage.toString();
      }
    } on DioException catch (error) {
      throw MyHandle.handleDioError(error.type);
    }
  }

  Future<String> logout() async {
    Uri url = Uri.parse("$host/logout");

    try {
      final response = await dio.postUri(
        url, 
        data: null,
        options: Options(
          headers: <String, String>{ 
            'Accept' : 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${globalLoginResponse!.accessToken}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ), 
      );
      if(response.statusCode == 200) {
        var body = response.data;
        return body['message'] as String;
      } else {
        throw response.statusMessage.toString();
      }
    } on DioException catch (error) {
      throw MyHandle.handleDioError(error.type);
    }
  }

  Future<GetDataResponseModel> getMyData(String? status, {required int pageIndex, int pageSize = 10}) async {
    List<Request> listData = [];

    String currentStatus;
    String baseUrl = "$host/requests?pageSize=$pageSize&pageIndex=$pageIndex";
    Uri url = Uri();

    switch (status) {
      case "Đã xong":
        currentStatus = "&status=2";
      case "Đã huỷ":
        currentStatus = "&status=3";
      case "Đang xử lý":
        currentStatus = "&status=1";
      default:
        currentStatus = "";
    }
    url = Uri.parse("$baseUrl$currentStatus");
    print(url);

    try {
      var response = await dio.getUri(
        url,
        options: Options(
          responseType: ResponseType.plain,
          headers: <String, String>{ 
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${globalLoginResponse!.accessToken}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ), 
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.data);

        var totalRequest = responseBody["data"]["total"] as int;
        var requestData = responseBody["data"]["requests"] as List;
        
        listData = requestData.map((jsonData) {
          return Request.fromJson(jsonData);
        }).toList();
        return GetDataResponseModel(totalRequests: totalRequest, listRequests: listData);
      } else {
        throw response.statusMessage.toString();
      }

    } on DioException catch (e) {
      throw MyHandle.handleDioError(e.type);
    }
  }

  Future<void> postDataWithoutFiles({required RequestType requestType, required Map<String, dynamic> formData}) async {
    Uri url = Uri.parse("$host/requests/${requestType.value}");
    print(url);

    try {
      final response = await dio.postUri(
        url,
        data: formData,
        options: Options(
          headers: <String, String>{ 
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${globalLoginResponse!.accessToken}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        )
      );

      if (response.statusCode != 200) {
        throw response.statusMessage.toString();
      }
    } on DioException catch (e) {
      throw MyHandle.handleDioError(e.type);
    }
  }

  Future<void> postDataWithFiles({required RequestType requestType, required Map<String, dynamic> data, required List<PlatformFile> files}) async {
    Uri url = Uri.parse("$host/requests/${requestType.value}");
    print(url);
    
    Map<String, dynamic> sendData = Map.from(data);

    List<MultipartFile > listFileToPost = [];

    await Future.wait(
      files.map((platformFile) async {
        var file = File(platformFile.path!);
        final mimeTypeData = lookupMimeType(file.path)!.split('/');

        final fileToPost = await MultipartFile.fromFile(
          file.path, 
          filename: platformFile.name,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
        );

        listFileToPost.add(fileToPost);
      })
    );

    sendData.addAll({
      "files": listFileToPost
    });

    final formData = FormData.fromMap(sendData, ListFormat.multiCompatible);

    try {
      final response = await dio.postUri(
        url,
        data: formData,
        options: Options(
          headers: <String, String>{ 
            'Content-Type': 'multipart/form-data; charset=UTF-8',
            'Accept': 'multipart/form-data; charset=UTF-8',
            'Authorization': 'Bearer ${globalLoginResponse!.accessToken}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        )
      );

      if (response.statusCode != 200) {
        throw response.statusMessage.toString();
      }
    } on DioException catch (e) {
      throw MyHandle.handleDioError(e.type);
    }
  }

  cancelTask() {
    dio.close(force: false);
  }

}