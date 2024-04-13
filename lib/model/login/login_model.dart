import 'package:datn/model/student/student_profile.dart';

class LoginResponseModel {
  String? accessToken;
  String? error;
  StudentProfile? user;

  LoginResponseModel({
    this.accessToken,
    this.error,
    this.user
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['token'] != null ? json['token'] as String : null,
      error: json['error'] != null ? json['error'] as String : null,
      user: json['user'] != null ? StudentProfile.fromJson(json['user'] as Map<String,dynamic>) : null,
    );
  }

}

class LoginRequestModel {
  String username;
  String password;
  
  LoginRequestModel({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': username.trim(),
      'password': password.trim(),
    };
  }

  @override
  String toString() => 'LoginRequestModel(username: $username, password: $password)';
}
