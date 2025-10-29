import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card_scanner/features/auth/data/services/firebase_auth_service.dart';
import 'package:business_card_scanner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:business_card_scanner/features/auth/domain/repositories/auth_repository.dart';
import 'package:business_card_scanner/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:business_card_scanner/features/auth/presentation/cubit/signup_cubit.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseAuthService>(
          create: (_) => FirebaseAuthService(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (ctx) => AuthRepositoryImpl(ctx.read<FirebaseAuthService>()),
        ),
        RepositoryProvider<SignUpUseCase>(
          create: (ctx) => SignUpUseCase(ctx.read<AuthRepository>()),
        ),
      ],
      child: BlocProvider<SignupCubit>(
        create: (ctx) => SignupCubit(ctx.read<SignUpUseCase>()),
        child: child,
      ),
    );
  }
}
