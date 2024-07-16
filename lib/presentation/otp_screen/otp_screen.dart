import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/otp_screen/bloc/otp_bloc.dart';
import 'package:smart_alert_dialog/models/alert_dialog_text.dart';
import 'package:smart_alert_dialog/smart_alert_dialog.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('otp_screen'.tr()),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocConsumer<OtpBloc, OtpState>(
            listener: (context, state) {
              if (state is OtpVerifiedState) {
                Navigator.pop(context, true);
              } else if (state is OtpFailureState) {
                showDialog(
                    context: context,
                    builder: (context) => SmartAlertDialog(
                          title: 'error'.tr(),
                          message: state.error,
                          text: AlertDialogText(
                              cancel: 'close'.tr(), confirm: "", dismiss: ""),
                        ));
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _otpController,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'otp'.tr(),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_otp'.tr();
                        } else if (value.length < 6) {
                          return 'please_enter_six'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child:  Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Text('verify'.tr(), style: const TextStyle(fontSize: 22)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<OtpBloc>().add(
                              OtpVerifyEvent(
                                verificationId: widget.verificationId,
                                otp: _otpController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
