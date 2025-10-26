import 'package:flutter/material.dart';
import '../../widgets/verification_screen.dart';
import 'email_screen.dart';
import 'finish_signup_screen.dart';

class EmailOtpScreen extends StatelessWidget {
  final String email;

  const EmailOtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return VerificationScreen(
      appBarTitle: 'Verify Email',
      title: 'OTP confirmation',
      subtitle: 'Enter the code we sent to $email',
      inputLabel: 'Enter OTP',
      inputHint: '000000',
      inputType: TextInputType.number,
      isPinCode: true,
      pinLength: 6,
      onBackPressed: () {},
      // ✅ NEW - EDIT BUTTON NAVIGATES BACK TO EMAIL ENTRY
      onEditPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const EmailScreen()),
          (route) => false,
        );
      },
      onContinuePressed: (value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FinishSignupScreen(email: email),
          ),
        );
      },
    );
  }
}
