import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/home_screen/bloc/home_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/home_screen/home_screen.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/bloc/login_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/register_screen/bloc/register_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/register_screen/register_screen.dart';
import 'package:osama_hasan_progress_soft/util/assets.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/share_preference_helper.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/shared_prefs_constants.dart';
import 'package:smart_alert_dialog/models/alert_dialog_text.dart';
import 'package:smart_alert_dialog/smart_alert_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(LoadRegexEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Screen"),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Login successful"),
                    backgroundColor: Colors.green,
                  ),
                );

                saveMobileNumber()
                    .whenComplete(() => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => HomeBloc(),
                              child: HomeScreen(),
                            ),
                          ),
                          (route) => false,
                        ));
              } else if (state is LoginFailureState) {
                showDialog(
                    context: context,
                    builder: (context) => SmartAlertDialog(
                          title: "Error",
                          message: state.error,
                          text: AlertDialogText(
                              dismiss: "", confirm: "", cancel: "Close"),
                        ));
              } else if (state is UserNotRegisteredState) {
                _showRegisterDialog();
              } else if (state is IncorrectPasswordState) {
                showDialog(
                    context: context,
                    builder: (context) => SmartAlertDialog(
                          title: "Error",
                          message: "Incorrect password",
                          text: AlertDialogText(
                              dismiss: "", confirm: "", cancel: "Close"),
                        ));
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
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      controller: _mobileController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (!RegExp(context.read<LoginBloc>().mobileRegex ?? "")
                            .hasMatch(value)) {
                          return 'Please enter a valid mobile number starting with +9627';
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
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (!RegExp(
                                context.read<LoginBloc>().passwordRegex ?? "")
                            .hasMatch(value)) {
                          return 'Password with min 8 characters, letters and numbers';
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
                          ),
                        );
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      color: Colors.indigo,
                      textColor: Colors.white,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text("Login", style: TextStyle(fontSize: 22)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(
                                LoginStartedEvent(
                                  _mobileController.text.trim(),
                                  _passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => RegisterBloc(),
                      child: RegisterScreen(),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> saveMobileNumber() async {
    await SharedPreferencesHelper.instance.saveString(
        SharedPrefsConstants.userMobileNumber, _mobileController.text);
  }
}
