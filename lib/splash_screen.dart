import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'core/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  //using firebase

  void _checkAuthentication() async {
    // Optional splash delay
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Re-check current auth state after delay to avoid stale value
    final User? user = FirebaseAuth.instance.currentUser;

    // Navigate based on authentication state
    if (user != null) {
      context.go(Routes.dashboard);
    } else {
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Business Card Scanner', // Updated app name
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
