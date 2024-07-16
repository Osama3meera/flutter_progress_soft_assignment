import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/bloc/login_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/login_screen/login_screen.dart';
import 'package:osama_hasan_progress_soft/presentation/otp_screen/bloc/otp_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/otp_screen/otp_screen.dart';
import 'package:osama_hasan_progress_soft/presentation/register_screen/bloc/register_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<RegisterBloc>().add(LoadRegexRegisterEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) async {
              if (state is RegisterOtpSentState) {
                bool otpVerified =
                    await _navigateToOtpScreen(state.verificationId);
                _navigateToOtpScreen(state.verificationId);

                if (otpVerified) {
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
                            title: 'error'.tr(),
                            message: 'otp_failed_verification'.tr(),
                            text: AlertDialogText(
                                cancel: 'close'.tr(), dismiss: "", confirm: ""),
                          ));
                }
              } else if (state is RegisterFailureState) {
                showDialog(
                    context: context,
                    builder: (context) => SmartAlertDialog(
                          title: 'error'.tr(),
                          message: state.error,
                          text: AlertDialogText(
                              cancel: 'close'.tr(), confirm: "", dismiss: ""),
                        ));
              } else if (state is RegisterSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('registration_successful'.tr()),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => LoginBloc(),
                        child: const LoginScreen(),
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
                          return 'please_enter_you_name'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'mobile_number'.tr(),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      controller: _mobileController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_mobile'.tr();
                        }
                        if (!RegExp(context.read<RegisterBloc>().mobileRegex!)
                            .hasMatch(value)) {
                          return 'valid_mobile_msg'.tr();
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
                      decoration: InputDecoration(
                        labelText: 'password'.tr(),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_password'.tr();
                        }
                        if (!RegExp(
                                context.read<RegisterBloc>().passwordRegex ??
                                    "")
                            .hasMatch(value)) {
                          return 'valid_password_msg'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'confirm_password'.tr(),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 're_enter_password'.tr();
                        }
                        if (value != _passwordController.value.text) {
                          return 'password_no_match'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      color: Colors.indigo,
                      textColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Text('register'.tr(),
                            style: const TextStyle(fontSize: 22)),
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
