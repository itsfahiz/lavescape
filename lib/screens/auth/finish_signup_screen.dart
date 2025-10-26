import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme.dart';
import '../../widgets/custom_button.dart';
import 'profile_created_screen.dart';

class FinishSignupScreen extends StatefulWidget {
  final String email;

  const FinishSignupScreen({super.key, required this.email});

  @override
  State<FinishSignupScreen> createState() => _FinishSignupScreenState();
}

class _FinishSignupScreenState extends State<FinishSignupScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController(
      text: widget.email,
    ); //  Initialize with email
    _dobController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finish Signing Up',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 2,
        backgroundColor: AppTheme.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              Text('Full Name', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8.h),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(hintText: 'Enter your full name'),
              ),
              SizedBox(height: 20.h),

              // Date of Birth
              Text(
                'Date of Birth',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: TextField(
                  controller: _dobController,
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'MM/DD/YYYY',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Email Address
              Text(
                'Email Address',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: false, //  Read-only since it's pre-filled
                decoration: InputDecoration(
                  hintText: 'your@email.com',
                  suffixIcon: const Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20.h),

              // Password
              Text(
                'Create Password',
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
              SizedBox(height: 20.h),

              // Confirm Password
              Text(
                'Confirm Password',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(hintText: '••••••••'),
              ),
              SizedBox(height: 40.h),

              // Button
              CustomButton(
                text: 'Agree and Continue',
                onPressed: () {
                  if (_fullNameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _dobController.text.isEmpty ||
                      _passwordController.text.isEmpty ||
                      _confirmPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                  } else if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileCreatedScreen(),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 24.h),

              // Terms Text
              Center(
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: AppTheme.gray,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'By taping Agree and Continue, I accept Lavescape\'s ',
                      ),
                      TextSpan(
                        text:
                            'Terms, Payment Terms, and Notifications Policy, ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: 'and acknowledge the '),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
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
