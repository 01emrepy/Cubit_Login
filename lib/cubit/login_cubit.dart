import 'package:bloc/bloc.dart';
import 'package:cubitlogin/model/login_request_model.dart';
import 'package:cubitlogin/model/login_response_model.dart';
import 'package:cubitlogin/service/Ilogin_service.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final TextEditingController EmailController;
  final TextEditingController PasswordController;
  final GlobalKey<FormState> formkey;
  bool isLoginFail = false;
  bool isLoading = false;
  final ILoginService service;
  LoginCubit(this.EmailController, this.PasswordController, this.formkey,
      {required this.service})
      : super(LoginInitial());

  Future<void> postUserModel() async {
    if (formkey.currentState != null && formkey.currentState!.validate()) {
      changeLoadingView();
      final data = await service.postUserLogin(LoginRequestModel(
          email: EmailController.text.trim(),
          password: PasswordController.text.trim()));
      changeLoadingView();

      if (data is LoginResponeModel) {
        emit(LoginComplete(data));
      }
    } else {
      isLoginFail = true;
      emit(LoginValidateState(isLoginFail));
    }
  }

  void changeLoadingView() {
    isLoading = !isLoading;
    emit(LoginLoading(isLoading));
  }
}
