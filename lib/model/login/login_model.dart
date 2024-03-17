import 'package:datn/model/login/user.dart';

class LoginResponseModel {

  String? accessToken;
  int? expiredTime;
  String? error;
  User? user;

  LoginResponseModel({
    this.accessToken,
    this.expiredTime,
    this.error,
    this.user
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['token'] != null ? json['token'] as String : null,
      expiredTime: json['expires_in'] != null ? json['expires_in'] as int : null,
      error: json['error'] != null ? json['error'] as String : null,
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String,dynamic>) : null,
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
