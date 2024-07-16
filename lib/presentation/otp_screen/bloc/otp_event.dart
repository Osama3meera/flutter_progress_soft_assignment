part of 'otp_bloc.dart';

abstract class OtpEvent {}

class OtpVerifyEvent extends OtpEvent {
  final String verificationId;
  final String otp;
  OtpVerifyEvent({required this.verificationId, required this.otp});
}