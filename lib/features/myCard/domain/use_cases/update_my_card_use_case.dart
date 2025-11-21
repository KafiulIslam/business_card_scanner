import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';
import 'package:business_card_scanner/features/myCard/domain/repositories/my_card_repository.dart';

class UpdateMyCardUseCase {
  final MyCardRepository _myCardRepository;

  UpdateMyCardUseCase(this._myCardRepository);

  Future<void> call(String documentId, MyCardModel card) async {
    await _myCardRepository.updateMyCard(documentId, card);
  }
}

