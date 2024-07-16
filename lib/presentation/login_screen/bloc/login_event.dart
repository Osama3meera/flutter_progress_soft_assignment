part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoadRegexEvent extends LoginEvent {}

class LoginStartedEvent extends LoginEvent {
  final String mobileNumber;
  final String password;

  LoginStartedEvent(this.mobileNumber, this.password);
}