import 'dart:convert';

class LoginResponseModel {
  final String? message;
  final String? token;

  LoginResponseModel({
    this.message,
    this.token,
  });

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      message: map['message'],
      token: map['token'],
    );
  }

  factory LoginResponseModel.fromJson(String source) => LoginResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
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
      'username': username.trim(),
      'password': password.trim(),
    };
  }

  @override
  String toString() => 'LoginRequestModel(username: $username, password: $password)';
}
