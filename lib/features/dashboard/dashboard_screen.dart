import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Text('Dashboard'),
        TextButton(onPressed: () async {
          FirebaseAuth.instance.signOut();
          context.go(Routes.login);
        }, child: const Text('Logout'))
      ],)),
    );
  }
}
