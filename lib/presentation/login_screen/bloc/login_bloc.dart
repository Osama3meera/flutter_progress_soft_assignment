import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/share_preference_helper.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/shared_prefs_constants.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String? mobileRegex = "";
  String? passwordRegex = "";

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});

    on<LoginStartedEvent>((event, emit) {
      emit.call(LoginStartedState());
    });

    on<LoadRegexEvent>((event, emit) async {
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
}
