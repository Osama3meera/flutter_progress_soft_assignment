import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/bloc/login_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/login_screen.dart';
import 'package:osama_hasan_progress_soft/util/assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    _loadConfigData().whenComplete(() {
      navigateToLoginScreen();
    });
  }

  void navigateToLoginScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => LoginBloc(),
              child: const LoginScreen(),
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

        data.forEach((key, value) {
          if (key.trim() == "mobileRegex") {
            mobileRegex = value;
          } else if (key.trim() == "passwordRegex") {
            passwordRegex = value;
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
