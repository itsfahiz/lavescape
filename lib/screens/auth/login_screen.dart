import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lavescape/screens/explore/explore_screen.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import 'sign_up_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailOrPhoneController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailOrPhoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //  HELPER FUNCTION: DETECT IF EMAIL OR PHONE
  bool _isEmail(String value) {
    return value.contains('@') && value.contains('.');
  }

  //  HELPER FUNCTION: VALIDATE INPUT
  String? _validateInput(String value) {
    if (value.isEmpty) {
      return 'Email or phone number required';
    }

    if (_isEmail(value)) {
      // Email validation
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(value)) {
        return 'Invalid email format';
      }
    } else {
      // Phone validation (at least 10 digits)
      final phoneRegex = RegExp(r'^[0-9+\-\s()]{10,}$');
      if (!phoneRegex.hasMatch(value)) {
        return 'Invalid phone number';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset('assets/icons/logo_lavescape.svg'),
              ),
              SizedBox(height: 40.h),

              // Title
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 16.h),

              // Subtitle
              Text(
                'Log in to access Lavescape bookings',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 40.h),

              // Email/Phone with validation
              Text(
                'Email Address / Phone Number',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _emailOrPhoneController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'you@example.com or +1234567890',
                  errorText: _emailOrPhoneController.text.isEmpty
                      ? null
                      : _validateInput(_emailOrPhoneController.text),
                ),
                onChanged: (value) {
                  setState(() {}); //  REBUILD TO SHOW VALIDATION
                },
              ),
              SizedBox(height: 20.h),

              // Password
              Text('Password', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8.h),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Forgot Password
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot Password?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // Login Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return CustomButton(
                    text: 'Log In',
                    isLoading: authProvider.isLoading,
                    onPressed: () {
                      final input = _emailOrPhoneController.text.trim();
                      final password = _passwordController.text;

                      // ✅ VALIDATE INPUT
                      final validationError = _validateInput(input);
                      if (validationError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(validationError)),
                        );
                        return;
                      }

                      if (password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password required')),
                        );
                        return;
                      }

                      //  DETECT AND LOGIN
                      if (_isEmail(input)) {
                        // Login with email
                        authProvider
                            .login(email: input, password: password)
                            .then((_) {
                              if (authProvider.isLoggedIn) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const ExploreScreen(),
                                  ),
                                  (route) => false,
                                );
                              } else if (authProvider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.errorMessage!),
                                  ),
                                );
                              }
                            });
                      } else {
                        // Login with phone
                        authProvider
                            .login(phoneNumber: input, password: password)
                            .then((_) {
                              if (authProvider.isLoggedIn) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const ExploreScreen(),
                                  ),
                                  (route) => false,
                                );
                              } else if (authProvider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.errorMessage!),
                                  ),
                                );
                              }
                            });
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 24.h),

              // Or Divider
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

              // Sign Up Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Sign up',
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
