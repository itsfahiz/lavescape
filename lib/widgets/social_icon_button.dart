import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../config/theme.dart';

class SocialIconButton extends StatelessWidget {
  final String svgPath;
  final String label;
  final VoidCallback onTap;

  const SocialIconButton({
    super.key,
    required this.svgPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: 50.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderGray),
          borderRadius: BorderRadius.circular(8.r),
          color: AppTheme.white,
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            height: 24.h,
            width: 24.w,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
