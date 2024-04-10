import 'package:datn/model/login/login_model.dart';
import 'package:datn/model/student/student_profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageServices {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions.defaultOptions
  );

  Future<void> writeAccessToken(String? token) async {
    await secureStorage.write(key: "access_token", value: token);
  }

  Future<String?> getAccessToken() async {
    final containAccessToken = await secureStorage.containsKey(key: "access_token");

    if (!containAccessToken) {
      return null;
    }

    final accessToken = await secureStorage.read(key: "access_token");

    return accessToken;
  }
  
  Future<bool> isContainSavedAccount() async {
    final containSavedUsername = await secureStorage.containsKey(key: "username");
    final containSavedPassword = await secureStorage.containsKey(key: "password");
    return containSavedUsername && containSavedPassword;
  }

  Future<void> writeSaveAccount(LoginRequestModel account) async {
    await secureStorage.write(key: "username", value: account.username);
    await secureStorage.write(key: "password", value: account.password);
  }

  Future<LoginRequestModel?> getSavedAccount() async {
    final isContain = await isContainSavedAccount(); 
    if (!isContain) {
      return null;
    }

    final savedUsername = await secureStorage.read(key: "username");
    final savedPassword = await secureStorage.read(key: "password");
    
    return LoginRequestModel(username: savedUsername ?? "", password: savedPassword ?? "");
  }

  Future<void> deleteSavedAccount() async {
    await secureStorage.delete(key: "username");
    await secureStorage.delete(key: "password");
  }

  Future<void> writeSaveUserInfo(LoginResponseModel loginResponse) async {
    await secureStorage.write(key: "access_token", value: loginResponse.accessToken);
    await secureStorage.write(key: "email", value:loginResponse.user?.email);
    await secureStorage.write(key: "name", value: loginResponse.user?.name);
    await secureStorage.write(key: "id", value: loginResponse.user?.id);
  }

  Future<LoginResponseModel?> getSaveUserInfo() async {
    final accessToken = await secureStorage.read(key: "access_token");
    final saveUserName = await secureStorage.read(key: "name");
    final savedUserEmail = await secureStorage.read(key: "email");
    final savedUserId = await secureStorage.read(key: "id");

    if (accessToken == null || savedUserId == null || savedUserEmail == null || saveUserName == null) {
      return null;
    }
    
    return LoginResponseModel(accessToken: accessToken, user: StudentProfile(email: savedUserEmail, name: saveUserName, id: savedUserId));
  }

  Future<void> deleteSavedUserInfo() async {
    await secureStorage.delete(key: "access_token");
    await secureStorage.delete(key: "email");
    await secureStorage.delete(key: "name");
    await secureStorage.delete(key: "id");
  }
}