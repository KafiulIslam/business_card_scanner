import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';
import 'package:business_card_scanner/features/myCard/domain/repositories/my_card_repository.dart';

class GetMyCardsUseCase {
  final MyCardRepository _myCardRepository;

  GetMyCardsUseCase(this._myCardRepository);

  Future<List<MyCardModel>> call(String uid) async {
    return await _myCardRepository.getMyCardsByUid(uid);
  }
}

