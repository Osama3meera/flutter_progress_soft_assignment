part of 'register_bloc.dart';

// register_state.dart
abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterOtpSentState extends RegisterState {
  final String verificationId;
  RegisterOtpSentState({required this.verificationId});
}

class RegisterSuccessState extends RegisterState {}

class RegisterFailureState extends RegisterState {
  final String error;
  RegisterFailureState(this.error);
}


