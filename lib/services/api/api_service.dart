// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:uuid/v1.dart';

import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/login/login_model.dart';
import 'package:datn/model/request/request_model.dart';
import 'package:datn/services/firebase/firebase_services.dart';
import 'package:datn/services/handle/my_handle.dart';

class APIService {

  static const host = "http://192.168.1.5:3000";
  static const myHost = "https://uet-student-cc10e59e8dec.herokuapp.com/api/v1";

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
    Uri url = Uri.parse("$myHost/login");
    
    try {
      final response = await Dio().postUri(
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
    Uri url = Uri.parse("$myHost/logout");

    try {
      final response = await Dio().postUri(
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

  // Future<List<Request>> getData(String? status, int startIndex, String userId, {int limit = 10}) async {
  //   List<Request> listData = [];

  //   String currentStatus;
  //   String baseUrl = "$host/requests?_sort=id&_order=desc&userId=$userId&_start=$startIndex&_limit=$limit";
  //   Uri url = Uri();

  //   switch (status) {
  //     case "Đã xong":
  //       currentStatus = "&status=completed";
  //     case "Đã huỷ":
  //       currentStatus = "&status=canceled";
  //     case "Đang xử lý":
  //       currentStatus = "&status=processing";
  //     default:
  //       currentStatus = "";
  //   }
  //   url = Uri.parse("$baseUrl$currentStatus");
  //   print(url);

  //   try {
  //     var response = await Dio().getUri(
  //       url,
  //       options: Options(
  //         responseType: ResponseType.plain,
  //         headers: <String, String>{ 
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           'Accept': 'application/json; charset=UTF-8',
  //           'Authorization': 'Bearer ${globalLoginResponse!.accessToken}'
  //         },
  //         followRedirects: false,
  //         validateStatus: (status) {
  //           return status != null && status < 500;
  //         },
  //       ), 
  //     );

  //     if (response.statusCode == 200) {
  //       var responseBody = jsonDecode(response.data) as List<dynamic>;
  //       if (responseBody.isNotEmpty) {
  //         listData = responseBody.map((jsonData) {
  //           return Request.fromJson(jsonData);
  //         }).toList();
  //         return listData;
  //       }
  //     } else {
  //       return [];
  //     }

  //   } on DioException catch (e) {
  //     print("GET DATA ERROR: ${e.message.toString()}");
  //     throw MyHandle.handleDioError(e.type);
  //   }
  //   return [];
  // }

  Future<String?> postData({required Request request, required Map<String, dynamic> requestInfo}) async {
    Uri url = Uri.parse("$host/requests");

    var bodyMap = request.toMap();
    bodyMap.addAll({"info": requestInfo});
    
    try {
      final response = await Dio().postUri(
        url, 
        data: jsonEncode(bodyMap),
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
        ), 
      );
      if(response.statusCode == 201) {
        return null;
      } else {
        print(response.statusMessage);
        return "#${response.statusCode}: ${response.statusMessage}";
      }
    } on DioException catch (e) {
      print(e.toString());
      return MyHandle.handleDioError(e.type);
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

  //TODO: NEW API
  Future<GetDataResponseModel> getMyData(String? status, {required int pageIndex, int pageSize = 10}) async {
    List<Request> listData = [];

    String currentStatus;
    String baseUrl = "$myHost/requests?pageSize=$pageSize&pageIndex=$pageIndex";
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
      var response = await Dio().getUri(
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
        var responseBody = jsonDecode(response.data) as Map<String, dynamic>;

        var totalRequest = responseBody["data"]["total"] as int;
        var requestData = responseBody["data"]["requests"] as List<dynamic>;
        
        listData = requestData.map((jsonData) {
          return Request.fromJson(jsonData);
        }).toList();
        return GetDataResponseModel(totalRequests: totalRequest, listRequests: listData);
      } else {
        throw response.statusMessage.toString();
      }

    } on DioException catch (e) {
      print("GET DATA ERROR: ${e.message.toString()}");
      throw MyHandle.handleDioError(e.type);
    }
  }

  Future<void> postDataWithoutFiles({required Map<String, dynamic> data}) async {
    //TODO: THAY DOI URL
    Uri url = Uri.parse("$host/requests");

    try {
      final response = await Dio().postUri(
        url,
        data: data,
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

      if (response.statusCode != 201) {
        throw response.statusMessage.toString();
      }
    } on DioException catch (e) {
      throw MyHandle.handleDioError(e.type);
    }
  }

  Future<void> postDataWithinFiles({required Map<String, dynamic> data, required List<PlatformFile> files}) async {
    //TODO: THAY DOI URL
    Uri url = Uri.parse("$host/requests");
    
    Future.wait(
      files.map((platformFile) async {
        var file = File(platformFile.path!);
        final mimeTypeData = lookupMimeType(file.path)!.split('/');

        final fileToPost = await MultipartFile.fromFile(
          file.path, 
          filename: platformFile.name,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
        );
        data.addAll({"files": fileToPost});
      })
    );

    final formData = FormData.fromMap(data, ListFormat.multiCompatible);

    try {
      final response = await Dio().postUri(
        url,
        data: formData,
        options: Options(
          headers: <String, String>{ 
            'Authorization': 'Bearer ${globalLoginResponse!.accessToken}'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        )
      );

      if (response.statusCode != 201) {
        throw response.statusMessage.toString();
      }
    } on DioException catch (e) {
      throw MyHandle.handleDioError(e.type);
    }
  }

}