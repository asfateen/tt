import 'package:flutter/material.dart';
import 'package:batee5/features/authentication_feature/1_presentation/pages/widgets/custom_app_bar_leading.dart';
import 'package:batee5/a_core/widgets/batee5_app_bar/batee5_app_bar.dart';
import 'package:batee5/features/authentication_feature/1_presentation/pages/enter_OTP/components/OTP_field.dart';
import 'package:batee5/features/authentication_feature/1_presentation/pages/widgets/submit_text_button.dart';
import 'package:batee5/features/authentication_feature/data/auth_service.dart';
import 'package:batee5/features/authentication_feature/1_presentation/pages/password_screen/password_screen.dart';

class EmailVerification extends StatefulWidget {
  final bool passwordReset;
  final String email;
  
  const EmailVerification({
    super.key, 
    required this.passwordReset,
    required this.email,
  });

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool loading = false;
  int time = 30;
  String inputOTP = '';
  String? errorMessage;
  final AuthService _authService = AuthService();
  final String realOTP = '1234'; // TODO: Remove hardcoded OTP

  Future<void> _verifyOTP() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final result = await _authService.verifyOTP(widget.email, inputOTP);
      
      if (result['success']) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PasswordScreen(
              passwordReset: widget.passwordReset,
            ),
          ),
        );
      } else {
        setState(() {
          errorMessage = result['message'];
        });
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: Batee5AppBar(
        toolbarHeight: height * .25,
        title: CustomAppBarLeading(
          backButton: true,
          midText: "Verify Email",
          description: "We've sent a verification code to ${widget.email}",
        ),
        barHeight: height * .233,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            OTPField(
              otp: realOTP,
              numberOfFields: 4,
              onChanged: (val) {
                setState(() {
                  inputOTP = val;
                });
              },
            ),
            const SizedBox(height: 73),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            SubmitTextButton(
              text: loading ? "Verifying..." : "Verify",
              onPressed: _verifyOTP,
              isEnabled: !loading && inputOTP.length == 4,
            ),
          ],
        ),
      ),
    );
  }
}