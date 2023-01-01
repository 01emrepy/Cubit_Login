import 'dart:io';

import 'package:cubitlogin/model/login_request_model.dart';
import 'package:cubitlogin/model/login_response_model.dart';
import 'package:cubitlogin/service/Ilogin_service.dart';
import 'package:dio/dio.dart';

class LoginService extends ILoginService {
  LoginService(Dio dio) : super(dio);

  @override
  Future<LoginResponeModel?> postUserLogin(LoginRequestModel model) async {
    final response = await dio.post(loginPath, data: model);

    if (response.statusCode == HttpStatus.ok) {
      return LoginResponeModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}
