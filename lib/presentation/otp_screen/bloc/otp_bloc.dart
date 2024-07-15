import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OtpBloc() : super(OtpInitialState()) {
    on<OtpVerifyEvent>(_onOtpVerify);
  }

  void _onOtpVerify(OtpVerifyEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otp,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        emit(OtpVerifiedState());
      } else {
        emit(OtpFailureState("OTP Verification Failed"));
      }
    } catch (e) {
      emit(OtpFailureState(e.toString()));
    }
  }
}
