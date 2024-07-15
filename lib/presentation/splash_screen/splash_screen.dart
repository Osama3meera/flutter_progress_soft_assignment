import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/bloc/login_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/login_screen.dart';
import 'package:osama_hasan_progress_soft/util/assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/share_preference_helper.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/shared_prefs_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String mobileRegex = "";
  String passwordRegex = "";

  @override
  void initState() {
    super.initState();

    isConfigDataLoaded().then((value) {
      if (!value) {
        _loadConfigData().whenComplete(() {
          navigateToLoginScreen();
        });
      } else {
        navigateToLoginScreen();
      }
    });
  }

  Future<bool> isConfigDataLoaded() async {
    String? mobileRegex = await SharedPreferencesHelper.instance
            .getString(SharedPrefsConstants.mobileRegex) ??
        "";
    String? passwordRegex = await SharedPreferencesHelper.instance
            .getString(SharedPrefsConstants.passwordRegex) ??
        "";

    return mobileRegex.isNotEmpty && passwordRegex.isNotEmpty;
  }

  void navigateToLoginScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => LoginBloc(),
              child: LoginScreen(
                  mobileRegex: mobileRegex, passwordRegex: passwordRegex),
            ),
          ));
    });
  }

  Future<void> _loadConfigData() async {
    try {
      DocumentSnapshot configSnapshot = await FirebaseFirestore.instance
          .collection('config')
          .doc('jordan')
          .get();

      if (configSnapshot.exists) {
        Map<String, dynamic> data =
            configSnapshot.data() as Map<String, dynamic>;

        data.forEach((key, value) async {
          if (key.trim() == "mobileRegex") {
            await SharedPreferencesHelper.instance
                .saveString(SharedPrefsConstants.mobileRegex, value);
          } else if (key.trim() == "passwordRegex") {
            await SharedPreferencesHelper.instance
                .saveString(SharedPrefsConstants.passwordRegex, value);
          }
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error loading configuration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.progressSoftLogo),
            const SizedBox(
              height: 10,
            ),
            const Text("Copyright")
          ],
        ),
      ),
    );
  }
}
