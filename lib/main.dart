import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lavescape/config/theme.dart';
import 'package:lavescape/providers/auth_provider.dart';
import 'package:lavescape/providers/search_provider.dart';
import 'package:lavescape/providers/trip_provider.dart';
import 'package:lavescape/screens/auth/sign_up_screen.dart';
import 'package:lavescape/screens/explore/explore_screen.dart';
import 'package:lavescape/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => TripProvider()),
            ChangeNotifierProvider(create: (_) => SearchProvider()),
          ],
          child: MaterialApp(
            title: 'Lavescape',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            //SPLASH SCREEN AS HOME
            home: const SplashScreen(),
            //ROUTES FOR NAVIGATION
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/explore': (context) => const ExploreScreen(),
            },
          ),
        );
      },
    );
  }
}
