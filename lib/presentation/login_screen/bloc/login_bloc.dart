import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/share_preference_helper.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/shared_prefs_constants.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? mobileRegex = "";
  String? passwordRegex = "";

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});

    on<LoginStartedEvent>((event, emit) async {
      emit(LoginLoadingState());
      await _login(event, emit);
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

  Future<void> _login(LoginStartedEvent event, Emitter<LoginState> emit) async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: event.mobileNumber)
          .get();

      if (userSnapshot.docs.isEmpty) {
        emit(UserNotRegisteredState());
      } else {
        var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        String storedPassword = userData['password'];

        if (storedPassword == event.password) {
          updateUserState();
          emit(LoginSuccessState());
        } else {
          emit(IncorrectPasswordState());
        }
      }
    } catch (e) {
      emit(LoginFailureState(e.toString()));
    }
  }

  Future<void> updateUserState() async {
    await SharedPreferencesHelper.instance
        .saveBool(SharedPrefsConstants.userLoggedIn, true);
  }
}
