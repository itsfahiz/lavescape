import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_icon_button.dart';
import 'email_otp_screen.dart';
import 'login_screen.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset('assets/icons/logo_lavescape.svg'),
              ),
              SizedBox(height: 40.h),

              Text(
                'Email Address',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 16.h),

              Text(
                'We\'ll use this for important updates and password resets',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 40.h),

              Text(
                'Email Address',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'you@example.com'),
              ),
              SizedBox(height: 12.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialIconButton(
                    svgPath: 'assets/icons/facebook.svg',
                    label: 'Facebook',
                    onTap: () {},
                  ),
                  SocialIconButton(
                    svgPath: 'assets/icons/google.svg',
                    label: 'Google',
                    onTap: () {},
                  ),
                  SocialIconButton(
                    svgPath: 'assets/icons/apple.svg',
                    label: 'Apple',
                    onTap: () {},
                  ),
                  SocialIconButton(
                    svgPath: 'assets/icons/phone.svg',
                    label: 'Phone',
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 40.h),

              CustomButton(
                text: 'Continue',
                onPressed: () {
                  if (_emailController.text.contains('@')) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            EmailOtpScreen(email: _emailController.text),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter valid email')),
                    );
                  }
                },
              ),
              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(child: Divider(color: AppTheme.borderGray)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      'OR',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(child: Divider(color: AppTheme.borderGray)),
                ],
              ),
              SizedBox(height: 24.h),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
