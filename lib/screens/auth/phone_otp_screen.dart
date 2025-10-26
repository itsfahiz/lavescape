import 'package:flutter/material.dart';
import '../../widgets/verification_screen.dart';
import 'email_screen.dart';
import 'sign_up_screen.dart';

class PhoneOtpScreen extends StatelessWidget {
  final String phoneNumber;

  const PhoneOtpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return VerificationScreen(
      appBarTitle: 'Verify Phone',
      title: 'OTP confirmation',
      subtitle: 'Enter the code we sent over SMS to $phoneNumber',
      inputLabel: 'Enter OTP',
      inputHint: '000000',
      inputType: TextInputType.number,
      isPinCode: true,
      pinLength: 6,
      onBackPressed: () {},
      // NEW - EDIT BUTTON NAVIGATES BACK TO PHONE ENTRY
      onEditPressed: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
          (route) => false,
        );
      },
      onContinuePressed: (value) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const EmailScreen()));
      },
    );
  }
}
