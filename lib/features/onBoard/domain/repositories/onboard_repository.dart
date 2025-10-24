import '../entities/onboard_entity.dart';

abstract class OnboardRepository {
  Future<List<OnboardEntity>> getOnboardData();
  Future<void> completeOnboarding();
}
