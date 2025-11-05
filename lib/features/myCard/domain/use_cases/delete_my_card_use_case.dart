import 'package:business_card_scanner/features/myCard/domain/repositories/my_card_repository.dart';

class DeleteMyCardUseCase {
  final MyCardRepository _myCardRepository;

  DeleteMyCardUseCase(this._myCardRepository);

  Future<void> call(String cardId) async {
    await _myCardRepository.deleteMyCard(cardId);
  }
}

