import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_onboard_data_use_case.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import 'onboard_state.dart';

class OnboardCubit extends Cubit<OnboardState> {
  final GetOnboardDataUseCase _getOnboardDataUseCase;
  final CompleteOnboardingUseCase _completeOnboardingUseCase;

  OnboardCubit({
    required GetOnboardDataUseCase getOnboardDataUseCase,
    required CompleteOnboardingUseCase completeOnboardingUseCase,
  })  : _getOnboardDataUseCase = getOnboardDataUseCase,
        _completeOnboardingUseCase = completeOnboardingUseCase,
        super(const OnboardInitial());

  Future<void> loadOnboardData() async {
    emit(const OnboardLoading());
    
    try {
      final onboardData = await _getOnboardDataUseCase();
      
      emit(OnboardLoaded(
        onboardData: onboardData,
        currentPage: 0,
        canGoNext: onboardData.length > 1,
        canGoPrevious: false,
      ));
    } catch (e) {
      emit(OnboardError('Failed to load onboarding data: ${e.toString()}'));
    }
  }

  void nextPage() {
    final currentState = state;
    if (currentState is OnboardLoaded) {
      final nextPage = currentState.currentPage + 1;
      final canGoNext = nextPage < currentState.onboardData.length - 1;
      final canGoPrevious = nextPage > 0;

      emit(currentState.copyWith(
        currentPage: nextPage,
        canGoNext: canGoNext,
        canGoPrevious: canGoPrevious,
      ));
    }
  }

  void previousPage() {
    final currentState = state;
    if (currentState is OnboardLoaded) {
      final previousPage = currentState.currentPage - 1;
      final canGoNext = previousPage < currentState.onboardData.length - 1;
      final canGoPrevious = previousPage > 0;

      emit(currentState.copyWith(
        currentPage: previousPage,
        canGoNext: canGoNext,
        canGoPrevious: canGoPrevious,
      ));
    }
  }

  void goToPage(int page) {
    final currentState = state;
    if (currentState is OnboardLoaded) {
      final canGoNext = page < currentState.onboardData.length - 1;
      final canGoPrevious = page > 0;

      emit(currentState.copyWith(
        currentPage: page,
        canGoNext: canGoNext,
        canGoPrevious: canGoPrevious,
      ));
    }
  }

  Future<void> skipOnboarding() async {
    try {
      await _completeOnboardingUseCase();
      emit(const OnboardCompleted());
    } catch (e) {
      emit(OnboardError('Failed to skip onboarding: ${e.toString()}'));
    }
  }

  Future<void> completeOnboarding() async {
    try {
      await _completeOnboardingUseCase();
      emit(const OnboardCompleted());
    } catch (e) {
      emit(OnboardError('Failed to complete onboarding: ${e.toString()}'));
    }
  }
}
