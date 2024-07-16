part of 'register_bloc.dart';

abstract class RegisterEvent {}

class RegisterStartedEvent extends RegisterEvent {
  final String phoneNumber;
  RegisterStartedEvent(this.phoneNumber);
}

class RegisterOtpSentEvent extends RegisterEvent {
  final String verificationId;
  RegisterOtpSentEvent({required this.verificationId});
}

class RegisterFailureEvent extends RegisterEvent {
  final String error;
  RegisterFailureEvent(this.error);
}

class RegisterSuccessEvent extends RegisterEvent {}

class RegisterCompletedEvent extends RegisterEvent {
  final String password;
  final String name;
  final String mobile;
  final int age;
  final String gender;

  RegisterCompletedEvent({
    required this.password,
    required this.name,
    required this.mobile,
    required this.age,
    required this.gender,
  });
}

