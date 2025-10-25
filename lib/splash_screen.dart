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

    // Initialize animation controller with 2-second duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Listen for animation completion to trigger navigation
    _controller.addListener(() async {
      if (_controller.status == AnimationStatus.completed) {

        // Wait for additional initialization time
        await Future.delayed(const Duration(seconds: 2), () {
          // TODO: Implement proper authentication check
          // Example implementation:
          // final RoleEnum? role = AppSharedPreferences.getString(key: AppConstants.roleName) != null
          //     ? RoleEnum.values.byName(AppSharedPreferences.getString(key: AppConstants.roleName) ?? "")
          //     : null;
          // final String? token = AppSharedPreferences.getString(key: StorageConstants.refreshToken);

          // Temporary token check (replace with actual implementation)
          final String token = '';

          // Navigate based on authentication state
          if (mounted) {
            if (token.isEmpty) {
              // User not authenticated - go to onboarding
              context.go(Routes.onboarding);
            } else {
              // User authenticated - go to main app
              // TODO: Replace with actual main app route
              context.go(Routes.onboarding);
            }
          }
        });
      }
    });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Clean up animation controller to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // TODO: Add background image when assets are available
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


            // App title/brand name
            Text(
              'Business Card Scanner', // Updated app name
              style: TextStyle(
                color: Colors.black,
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
