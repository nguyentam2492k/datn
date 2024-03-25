import 'package:datn/model/login/user.dart';

class LoginResponseModel {

  int? expiredTime;
  String? error;
  User? user;

  LoginResponseModel({
    this.expiredTime,
    this.error,
    this.user
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
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
