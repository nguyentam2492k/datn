import 'package:datn/model/login/login_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageServices {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );
  
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
    await secureStorage.deleteAll();
  }
}