import 'package:flutter/material.dart';
import 'package:osama_hasan_progress_soft/util/assets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Screen"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            Assets.progressSoftSmallLogo,
            height: 120,
            width: 120,
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
