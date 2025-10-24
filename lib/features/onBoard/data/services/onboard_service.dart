import '../../domain/entities/onboard_entity.dart';

abstract class OnboardService {
  Future<List<OnboardEntity>> getOnboardData();
  Future<void> completeOnboarding();
}
