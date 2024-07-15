part of 'otp_bloc.dart';

// otp_state.dart
abstract class OtpState {}

class OtpInitialState extends OtpState {}

class OtpLoadingState extends OtpState {}

class OtpVerifiedState extends OtpState {}

class OtpFailureState extends OtpState {
  final String error;
  OtpFailureState(this.error);
}
