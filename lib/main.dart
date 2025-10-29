import 'package:business_card_scanner/core/routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'core/di/di_providers.dart';
import 'firebase_options.dart';

void main() async {
  //initialize flutter project
  WidgetsFlutterBinding.ensureInitialized();

  // make the UI responsive
  await ScreenUtil.ensureScreenSize();

  //initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: AppProviders(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Cardigo',
              theme: AppTheme.lightTheme,
              // home: const MyHomePage(title: 'Test'), // Your main app widget
              themeMode: ThemeMode.light,
              routerConfig: router,
            ),
          ),
        );
      },
    );
  }
}
