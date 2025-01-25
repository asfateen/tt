import 'package:batee5/features/authentication_feature/1_presentation/pages/widgets/custom_app_bar_leading.dart';
import 'package:batee5/features/authentication_feature/1_presentation/pages/widgets/labeled_input_field.dart';
import 'package:batee5/features/authentication_feature/1_presentation/pages/widgets/submit_text_button.dart';
import 'package:batee5/a_core/widgets/batee5_app_bar/batee5_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:batee5/features/authentication_feature/data/auth_service.dart';

class PasswordScreen extends StatefulWidget {
  final bool passwordReset;

  const PasswordScreen({
    super.key,
    required this.passwordReset,
  });

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  String? password;
  String? confirmPassword;
  bool loading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Batee5AppBar(
        toolbarHeight: height * .25,
        title: CustomAppBarLeading(
          backButton: true,
          midText: widget.passwordReset ? "Reset Password" : "Set Password",
          description: "Choose a secure password for your account",
        ),
        barHeight: height * .233,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            LabeledInputField(
              hint: 'Password',
              label: 'Password',
              obscure: true,
              toggleObscurity: true,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
            ),
            const SizedBox(height: 16),
            LabeledInputField(
              hint: 'Confirm Password',
              label: 'Confirm Password',
              obscure: true,
              toggleObscurity: true,
              onChanged: (val) {
                setState(() {
                  confirmPassword = val;
                });
              },
            ),
            const SizedBox(height: 32),
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
              text: loading ? "Setting Password..." : "Set Password",
              onPressed: () {
                // Implement password setting logic
              },
              isEnabled: password != null && 
                        confirmPassword != null && 
                        password == confirmPassword &&
                        password!.length >= 8,
            ),
          ],
        ),
      ),
    );
  }
}
