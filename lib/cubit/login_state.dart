part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {
  LoginInitial();
}

class LoginLoading extends LoginState {
  final bool isLoading;

  LoginLoading(this.isLoading);
}

class LoginComplete extends LoginState {
  final LoginResponeModel model;
  LoginComplete(this.model);
}

class LoginValidateState extends LoginState {
  final bool isValidate;

  LoginValidateState(this.isValidate);
}
