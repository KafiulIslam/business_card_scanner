import '../entities/onboard_entity.dart';
import '../repositories/onboard_repository.dart';

class GetOnboardDataUseCase {
  final OnboardRepository _repository;

  GetOnboardDataUseCase(this._repository);

  Future<List<OnboardEntity>> call() async {
    return await _repository.getOnboardData();
  }
}
