import 'package:business_card_scanner/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository _repository;

  DeleteAccountUseCase(this._repository);

  Future<void> call() {
    return _repository.deleteAccount();
  }
}

