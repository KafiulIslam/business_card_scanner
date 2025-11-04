import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';
import 'package:business_card_scanner/features/myCard/domain/repositories/my_card_repository.dart';

class SaveMyCardUseCase {
  final MyCardRepository _myCardRepository;

  SaveMyCardUseCase(this._myCardRepository);

  Future<void> call(MyCardModel card) async {
    await _myCardRepository.saveMyCard(card);
  }
}

