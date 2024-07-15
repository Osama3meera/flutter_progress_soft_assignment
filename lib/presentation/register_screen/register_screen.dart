// register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/bloc/login_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/login_screen.dart';
import 'package:osama_hasan_progress_soft/presentation/otp_screen/bloc/otp_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/otp_screen/otp_screen.dart';
import 'package:osama_hasan_progress_soft/presentation/register_screen/bloc/register_bloc.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/share_preference_helper.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/shared_prefs_constants.dart';
import 'package:osama_hasan_progress_soft/widgets/age_picker_dropdown.dart';
import 'package:osama_hasan_progress_soft/widgets/gender_picker_dropdown.dart';
import 'package:smart_alert_dialog/models/alert_dialog_text.dart';
import 'package:smart_alert_dialog/smart_alert_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  int selectedAge = 18;
  String selectedGender = "male";
  String? mobileRegex = "";
  String? passwordRegex = "";

  @override
  void initState() {
    super.initState();
    getRegex();
  }

  Future<void> getRegex() async {
    mobileRegex = await SharedPreferencesHelper.instance
            .getString(SharedPrefsConstants.mobileRegex) ??
        "";

    passwordRegex = await SharedPreferencesHelper.instance
            .getString(SharedPrefsConstants.passwordRegex) ??
        "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) async {
            if (state is RegisterOtpSentState) {
              bool otpVerified =
                  await _navigateToOtpScreen(state.verificationId);
              _navigateToOtpScreen(state.verificationId);

              if (otpVerified) {
                // Proceed with completing the registration
                context.read<RegisterBloc>().add(RegisterCompletedEvent(
                      password: _passwordController.text.trim(),
                      name: _nameController.text.trim(),
                      mobile: _mobileController.text.trim(),
                      age: selectedAge,
                      gender: selectedGender,
                    ));
              } else {
                showDialog(
                    context: context,
                    builder: (context) => SmartAlertDialog(
                          title: "Error",
                          message: "OTP verification failed",
                          text: AlertDialogText(
                              cancel: "Close", dismiss: "", confirm: ""),
                        ));
              }
            } else if (state is RegisterFailureState) {
              showDialog(
                  context: context,
                  builder: (context) => SmartAlertDialog(
                        title: "Error",
                        message: state.error,
                        text: AlertDialogText(
                            cancel: "Close", confirm: "", dismiss: ""),
                      ));
            } else if (state is RegisterSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Registration successful"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => LoginBloc(),
                      child: LoginScreen(),
                    ),
                  ));
            }
          },
          builder: (context, state) {
            if (state is RegisterLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
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
                      if (!RegExp(mobileRegex!).hasMatch(value)) {
                        return 'Invalid mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  AgePickerDropdown(
                    onChanged: (value) {
                      setState(() {
                        selectedAge = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  GenderPickerDropdown(
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
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
                      if (!RegExp(passwordRegex ?? "").hasMatch(value)) {
                        return 'Invalid password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password';
                      }
                      if (value != _passwordController.value.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text("Register", style: TextStyle(fontSize: 22)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<RegisterBloc>().add(
                              RegisterStartedEvent(
                                  _mobileController.text.trim()),
                            );
                      }
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

  Future<bool> _navigateToOtpScreen(String verificationId) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => OtpBloc(),
          child: OtpScreen(verificationId: verificationId),
        ),
      ),
    );
  }
}
