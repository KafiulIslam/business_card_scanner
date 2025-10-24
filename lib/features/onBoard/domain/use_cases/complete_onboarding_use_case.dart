import '../repositories/onboard_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardRepository _repository;

  CompleteOnboardingUseCase(this._repository);

  Future<void> call() async {
    await _repository.completeOnboarding();
  }
}
