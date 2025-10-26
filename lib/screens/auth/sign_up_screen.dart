import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/country.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_icon_button.dart';
import 'phone_otp_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _phoneController;
  Country _selectedCountry = countries[0];

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.clear();
    super.dispose();
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
              Align(child: SvgPicture.asset('assets/icons/logo_lavescape.svg')),
              SizedBox(height: 40.h),

              Text(
                'Welcome to Lavescape',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                'Discover Authentic Experiences or Share Your Own—Log In or Sign Up to Get Started!',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: 40.h),

              Text(
                'Phone Number',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8.h),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderGray),
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppTheme.white,
                ),
                child: Row(
                  children: [
                    DropdownButton<Country>(
                      value: _selectedCountry,
                      underline: const SizedBox(),
                      items: countries.map((Country country) {
                        return DropdownMenuItem<Country>(
                          value: country,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              '${country.flag} ${country.dialCode}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (Country? newValue) {
                        if (newValue != null) {
                          setState(() => _selectedCountry = newValue);
                        }
                      },
                    ),

                    Container(
                      width: 1.w,
                      height: 24.h,
                      color: AppTheme.borderGray,
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppTheme.black,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                '${_selectedCountry.dialCode} (000) 000-0000',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppTheme.gray,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h,
                            ),
                            filled: true,
                            fillColor: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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

              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return CustomButton(
                    text: 'Continue',
                    isLoading: authProvider.isLoading,
                    onPressed: () {
                      if (_phoneController.text.isNotEmpty) {
                        final fullPhone =
                            '${_selectedCountry.dialCode}${_phoneController.text}';
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                PhoneOtpScreen(phoneNumber: fullPhone),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter phone number'),
                          ),
                        );
                      }
                    },
                  );
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
