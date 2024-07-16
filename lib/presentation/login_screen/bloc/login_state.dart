part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailureState extends LoginState {
  final String error;

  LoginFailureState(this.error);
}

class UserNotRegisteredState extends LoginState {}

class IncorrectPasswordState extends LoginState {}