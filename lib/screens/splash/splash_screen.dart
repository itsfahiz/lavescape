import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  //  NAVIGATE AFTER 2 SECONDS
  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isLoggedIn) {
        Navigator.of(context).pushReplacementNamed('/explore');
      } else {
        Navigator.of(context).pushReplacementNamed('/signup');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: SvgPicture.asset(
          'assets/icons/logo_lavescape.svg',
          width: 80.w,
          height: 80.h,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(AppTheme.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
