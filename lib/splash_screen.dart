import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'core/routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addListener(() async {
      if (_controller.status == AnimationStatus.completed) {
        // Get locale (example: from Localizations)

        // Implement your logic based on locale if needed
        // Example: print(locale.languageCode);

        await Future.delayed(const Duration(seconds: 2), () {
          // final RoleEnum? role =
          // AppSharedPreferences.getString(key: AppConstants.roleName) != null
          //     ? RoleEnum.values.byName(
          //   AppSharedPreferences.getString(key: AppConstants.roleName) ??
          //       "",
          // )
          //     : null;
          // final String? token = AppSharedPreferences.getString(
          //   key: StorageConstants.refreshToken,
          // );
          final String token = '';
          if (mounted) {
            if(token.isEmpty){
              context.go(Routes.onboarding);
            }else{
              context.go(Routes.onboarding);
            }

          }
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(AppAssets.splashScreen),
        //     fit: BoxFit.fill,
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AnimatedBuilder(
            //   animation: _controller,
            //   builder: (context, child) {
            //     return Opacity(
            //       opacity: _controller.value,
            //       child: Image.asset("assets/images/logo.png", width: 200.w),
            //     );
            //   },
            // ),
            10.verticalSpace,
            Text(
              'Sport App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
