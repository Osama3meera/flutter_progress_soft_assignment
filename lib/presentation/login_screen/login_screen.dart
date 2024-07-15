import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/bloc/login_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/register_screen/bloc/register_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/register_screen/register_screen.dart';
import 'package:osama_hasan_progress_soft/util/assets.dart';

class LoginScreen extends StatefulWidget {
  final String mobileRegex;
  final String passwordRegex;

  const LoginScreen(
      {super.key, required this.mobileRegex, required this.passwordRegex});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginStartedState) {
              // _login();
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    Assets.progressSoftSmallLogo,
                    height: 120,
                    width: 120,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: "Mobile number",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                    controller: _mobileController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (!RegExp(widget.mobileRegex).hasMatch(value)) {
                        return 'Invalid mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!RegExp(widget.passwordRegex).hasMatch(value)) {
                        return 'Invalid password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => RegisterBloc(),
                              child: RegisterScreen(),
                            ),
                          ));
                    },
                    child: const Text("Register",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.blue)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text("Login", style: TextStyle(fontSize: 22)),
                    ),
                    onPressed: () {
                      context.read<LoginBloc>().add(LoginStartedEvent());
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _login() async {
    String email = _mobileController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        print("user found");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showRegisterDialog();
      } else if (e.code == 'wrong-password') {}
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Not Registered'),
          content: const Text('Would you like to register?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Register'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
