import '../../domain/entities/onboard_entity.dart';
import '../../domain/repositories/onboard_repository.dart';
import '../services/onboard_service.dart';

class OnboardRepositoryImpl implements OnboardRepository {
  final OnboardService _service;

  OnboardRepositoryImpl(this._service);

  @override
  Future<List<OnboardEntity>> getOnboardData() async {
    return await _service.getOnboardData();
  }

  @override
  Future<void> completeOnboarding() async {
    await _service.completeOnboarding();
  }
}
