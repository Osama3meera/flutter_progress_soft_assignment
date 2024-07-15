import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/register_screen/bloc/register_bloc.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/share_preference_helper.dart';
import 'package:osama_hasan_progress_soft/util/shared_preference/shared_prefs_constants.dart';
import 'package:osama_hasan_progress_soft/widgets/age_picker_dropdown.dart';
import 'package:osama_hasan_progress_soft/widgets/gender_picker_dropdown.dart';

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
          listener: (context, state) {
            if (state is RegisterStartedState) {
              // _login();
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
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
                  const SizedBox(
                    height: 10,
                  ),
                  GenderPickerDropdown(
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
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
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)))),
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password';
                      }
                      if (value != _passwordController.value.text) {
                        return 'Invalid password';
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
                      context.read<RegisterBloc>().add(RegisterStartedEvent());
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
}
