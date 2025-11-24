import 'package:business_card_scanner/core/theme/app_assets.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
      context.go(Routes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 200.h,
                width: 200.w,
                child: Image.asset(
                  AppAssets.logo,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Gap(AppDimensions.spacing8),
            Text('Cardigo',
                style: AppTextStyles.headline2
                    .copyWith(fontSize: 36, color: Colors.black))
          ],
        ),
      ),
    );
  }
}
