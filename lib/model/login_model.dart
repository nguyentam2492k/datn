import 'package:datn/model/user.dart';

class LoginResponseModel {

  String accessToken;
  User user;

  LoginResponseModel({
    required this.accessToken,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json["accessToken"] as String,
      user: User.fromJson(json["user"]),
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
