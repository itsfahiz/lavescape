import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../config/theme.dart';
import 'custom_button.dart';

class VerificationScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String inputLabel;
  final String inputHint;
  final TextInputType inputType;
  final bool isPinCode;
  final int pinLength;
  final String appBarTitle;
  final VoidCallback onBackPressed;
  final VoidCallback onEditPressed;
  final Function(String) onContinuePressed;

  const VerificationScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.inputLabel,
    required this.inputHint,
    required this.inputType,
    required this.isPinCode,
    this.pinLength = 6,
    required this.appBarTitle,
    required this.onBackPressed,
    required this.onEditPressed,
    required this.onContinuePressed,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late TextEditingController _inputController;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void dispose() {
    if (!_isNavigating) {
      _inputController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _isNavigating = true;
          widget.onBackPressed();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.appBarTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.black),
            onPressed: () {
              _isNavigating = true;
              Navigator.pop(context);
              widget.onBackPressed();
            },
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
                // Title
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 16.h),

                // SUBTITLE WITH EDIT ICON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: _buildSubtitleSpans(widget.subtitle),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        _isNavigating = true;
                        widget.onEditPressed();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: SvgPicture.asset(
                          'assets/icons/edit.svg',
                          height: 20.h,
                          width: 20.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),

                // Input Label
                Text(
                  widget.inputLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),

                // PIN CODE OR TEXT INPUT
                if (widget.isPinCode)
                  PinCodeTextField(
                    appContext: context,
                    length: widget.pinLength,
                    obscureText: false,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8.r),
                      fieldHeight: 50.h,
                      fieldWidth: 45.w,
                      activeFillColor: AppTheme.lightGray,
                      activeColor: AppTheme.primaryColor,
                      inactiveColor: AppTheme.borderGray,
                      inactiveFillColor: AppTheme.lightGray,
                      selectedFillColor: AppTheme.white,
                      selectedColor: AppTheme.primaryColor,
                    ),
                    enableActiveFill: true,
                    controller: _inputController,
                    onChanged: (value) {},
                    autoFocus: false,
                  )
                else
                  TextField(
                    controller: _inputController,
                    keyboardType: widget.inputType,
                    decoration: InputDecoration(hintText: widget.inputHint),
                  ),

                SizedBox(height: 12.h),

                // Resend Code (only for OTP)
                if (widget.isPinCode)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive a code? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'Resend',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' in 300s'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 40.h),

                // Continue Button
                CustomButton(
                  text: 'Continue',
                  onPressed: () {
                    if (widget.isPinCode) {
                      if (_inputController.text.length == widget.pinLength) {
                        _isNavigating = true;
                        widget.onContinuePressed(_inputController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please enter ${widget.pinLength} digit code',
                            ),
                          ),
                        );
                      }
                    } else {
                      if (_inputController.text.contains('@')) {
                        _isNavigating = true;
                        widget.onContinuePressed(_inputController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter valid email'),
                          ),
                        );
                      }
                    }
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

                // Footer Link
                Center(
                  child: Text(
                    'Having trouble? Contact support',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ HELPER FUNCTION TO MAKE PHONE/EMAIL BOLD
  List<TextSpan> _buildSubtitleSpans(String subtitle) {
    // Find the phone number or email (last part after "to")
    final parts = subtitle.split('to');

    if (parts.length == 2) {
      final prefix = parts[0] + 'to';
      final contact = parts[1].trim();

      return [
        TextSpan(
          text: prefix + ' ',
          style: TextStyle(color: AppTheme.black),
        ),
        TextSpan(
          text: contact,
          style: TextStyle(
            color: AppTheme.black,
            fontWeight: FontWeight.bold, // ✅ BOLD
          ),
        ),
      ];
    }

    return [
      TextSpan(
        text: subtitle,
        style: TextStyle(color: AppTheme.black),
      ),
    ];
  }
}
