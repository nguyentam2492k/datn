import 'package:http/http.dart' as http;
import 'package:datn/model/login_model.dart';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async{
    Uri url = Uri(
      scheme: 'https',
      host: 'dummyjson.com',
      path: '/auth/login',
      // host: 'reqres.in',
      // path: '/api/login'
    );
    final response = await http.post(url, body: loginRequestModel.toJson());
    if(response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(response.body);
    } else {
      return LoginResponseModel(message: "Unknown Error!");
    }
  }
}