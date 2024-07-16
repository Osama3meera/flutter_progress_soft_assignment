import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/shared_prefs_constants.dart';

import '../../../util/shared_preference/share_preference_helper.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? mobileRegex = "";
  String? passwordRegex = "";

  RegisterBloc() : super(RegisterInitialState()) {
    on<RegisterStartedEvent>((event, emit) {
      emit(RegisterLoadingState());
      _onRegisterStarted(event.phoneNumber);
    });

    on<RegisterCompletedEvent>((event, emit) {
      emit(RegisterLoadingState());
      _onRegisterCompleted(
          event.password, event.name, event.mobile, event.gender, event.age);
    });

    on<RegisterOtpSentEvent>((event, emit) {
      emit.call(RegisterOtpSentState(verificationId: event.verificationId));
    });

    on<RegisterFailureEvent>((event, emit) {
      emit.call(RegisterFailureState(event.error));
    });

    on<RegisterSuccessEvent>((event, emit) {
      emit.call(RegisterSuccessState());
    });

    on<LoadRegexRegisterEvent>((event, emit) async {
      await getRegex();
    });
  }

  Future<void> getRegex() async {
    mobileRegex = await SharedPreferencesHelper.instance
            .getString(SharedPrefsConstants.mobileRegex) ??
        "";

    passwordRegex = await SharedPreferencesHelper.instance
            .getString(SharedPrefsConstants.passwordRegex) ??
        "";
  }

  void _onRegisterStarted(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          add(RegisterOtpSentEvent(verificationId: ''));
        },
        verificationFailed: (FirebaseAuthException e) {
          add(RegisterFailureEvent(e.message ?? "Verification Failed"));
        },
        codeSent: (String verificationId, int? resendToken) {
          add(RegisterOtpSentEvent(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Timeout");
        },
      );
    } catch (e) {
      add(RegisterFailureEvent(e.toString()));
    }
  }

  void _onRegisterCompleted(String password, String name, String mobile,
      String gender, int age) async {
    try {
      await _firestore.collection('users').doc(generateRandomString(30)).set({
        'name': name,
        'mobile': mobile,
        'age': age,
        'gender': gender,
        'password': password
      });

      add(RegisterSuccessEvent());
    } catch (e) {
      add(RegisterFailureEvent(e.toString()));
    }
  }

  String generateRandomString(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();

    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}
