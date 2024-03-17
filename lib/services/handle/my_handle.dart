import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

class MyHandle {
  static String handleDioError(DioExceptionType errorType) {
    switch (errorType) {
      case DioExceptionType.connectionTimeout:
        return "Connection Timeout";
      case DioExceptionType.sendTimeout:
        return "Send Timeout";
      case DioExceptionType.receiveTimeout:
        return "Receive Timeout";
      case DioExceptionType.badCertificate:
        return "Bad Certificate";
      case DioExceptionType.badResponse:
        return "Bad Response";
      case DioExceptionType.cancel:
        return "Canceled";
      case DioExceptionType.connectionError:
        return "Connection Error";
      case DioExceptionType.unknown:
        return "Unknown";
    }
  }

  static String? handleOpenFileResult(ResultType resultType) {
    switch (resultType) {
      case ResultType.done:
       return null;
      case ResultType.fileNotFound:
        return "File not found!";
      case ResultType.noAppToOpen:
        return "No app to open!";
      case ResultType.permissionDenied:
        return "Permission denied!";
      case ResultType.error:
        return ResultType.error.name;
    }
  }
}