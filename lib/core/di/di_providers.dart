import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card_scanner/features/auth/data/services/firebase_auth_service.dart';
import 'package:business_card_scanner/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:business_card_scanner/features/auth/domain/repositories/auth_repository.dart';
import 'package:business_card_scanner/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:business_card_scanner/features/auth/presentation/cubit/signup_cubit.dart';
import 'package:business_card_scanner/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:business_card_scanner/features/auth/presentation/cubit/login_cubit.dart';
import 'package:business_card_scanner/features/scanner/presentation/cubit/scan_cubit.dart';
import 'package:business_card_scanner/features/network/data/services/firebase_storage_service.dart';
import 'package:business_card_scanner/features/network/data/services/firebase_network_service.dart';
import 'package:business_card_scanner/features/network/data/repositories/network_repository_impl.dart';
import 'package:business_card_scanner/features/network/domain/repositories/network_repository.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/save_network_card_use_case.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/get_network_cards_use_case.dart';
import 'package:business_card_scanner/features/network/presentation/cubit/network_cubit.dart';

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
        RepositoryProvider<SignInUseCase>(
          create: (ctx) => SignInUseCase(ctx.read<AuthRepository>()),
        ),
        RepositoryProvider<FirebaseStorageService>(
          create: (_) => FirebaseStorageService(),
        ),
        RepositoryProvider<FirebaseNetworkService>(
          create: (_) => FirebaseNetworkService(),
        ),
        RepositoryProvider<NetworkRepository>(
          create: (ctx) => NetworkRepositoryImpl(ctx.read<FirebaseNetworkService>()),
        ),
        RepositoryProvider<SaveNetworkCardUseCase>(
          create: (ctx) => SaveNetworkCardUseCase(ctx.read<NetworkRepository>()),
        ),
        RepositoryProvider<GetNetworkCardsUseCase>(
          create: (ctx) => GetNetworkCardsUseCase(ctx.read<NetworkRepository>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SignupCubit>(
            create: (ctx) => SignupCubit(ctx.read<SignUpUseCase>()),
          ),
          BlocProvider<LoginCubit>(
            create: (ctx) => LoginCubit(ctx.read<SignInUseCase>()),
          ),
          BlocProvider<ScanCubit>(
            create: (_) => ScanCubit(),
          ),
          BlocProvider<NetworkCubit>(
            create: (ctx) => NetworkCubit(
              ctx.read<SaveNetworkCardUseCase>(),
              ctx.read<GetNetworkCardsUseCase>(),
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
