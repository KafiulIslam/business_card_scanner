import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/onboard_cubit.dart';
import '../cubit/onboard_state.dart';
import '../widgets/onboard_widget.dart';
import '../../domain/use_cases/get_onboard_data_use_case.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import '../../data/repositories/onboard_repository_impl.dart';
import '../../data/services/onboard_service_impl.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardCubit(
        getOnboardDataUseCase: GetOnboardDataUseCase(
          OnboardRepositoryImpl(OnboardServiceImpl()),
        ),
        completeOnboardingUseCase: CompleteOnboardingUseCase(
          OnboardRepositoryImpl(OnboardServiceImpl()),
        ),
      )..loadOnboardData(),
      child: const OnboardView(),
    );
  }
}

class OnboardView extends StatelessWidget {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardCubit, OnboardState>(
      listener: (context, state) {
        if (state is OnboardCompleted) {
          context.go(Routes.login);
        } else if (state is OnboardError) {
          _showSnackBar(context, state.message);
        }
      },
      child: BlocBuilder<OnboardCubit, OnboardState>(
        builder: (context, state) {
          if (state is OnboardLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          if (state is OnboardError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<OnboardCubit>().loadOnboardData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          
          if (state is OnboardLoaded) {
            return _buildOnboardContent(context, state);
          }
          
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildOnboardContent(BuildContext context, OnboardLoaded state) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  context.read<OnboardCubit>().goToPage(index);
                },
                itemCount: state.onboardData.length,
                itemBuilder: (context, index) {
                  final entity = state.onboardData[index];
                  return OnboardWidget(
                    title: entity.title,
                    description: entity.description,
                    iconName: entity.iconName,
                  );
                },
              ),
            ),
            _buildNavigation(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation(BuildContext context, OnboardLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildDotIndicator(state),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skip/Back Button
              if (state.currentPage == 0)
                TextButton(
                  onPressed: () => context.read<OnboardCubit>().skipOnboarding(),
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              else
                TextButton(
                  onPressed: () => context.read<OnboardCubit>().previousPage(),
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),

              // Next/Get Started Button
              ElevatedButton(
                onPressed: () {
                  if (state.currentPage < state.onboardData.length - 1) {
                    context.read<OnboardCubit>().nextPage();
                  } else {
                    context.read<OnboardCubit>().completeOnboarding();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: AppColors.primaryLight,
                ),
                child: Text(
                  state.currentPage == state.onboardData.length - 1
                      ? 'Get Started'
                      : 'Next',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(OnboardLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        state.onboardData.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: state.currentPage == index ? AppColors.primary : AppColors.gray500,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}