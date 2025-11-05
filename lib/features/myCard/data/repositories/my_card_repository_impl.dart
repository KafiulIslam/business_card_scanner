import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';
import 'package:business_card_scanner/features/myCard/domain/repositories/my_card_repository.dart';
import '../services/firebase_my_card_service.dart';

class MyCardRepositoryImpl implements MyCardRepository {
  final FirebaseMyCardService _firebaseMyCardService;

  MyCardRepositoryImpl(this._firebaseMyCardService);

  @override
  Future<void> saveMyCard(MyCardModel card) async {
    await _firebaseMyCardService.saveMyCard(card);
  }

  @override
  Future<List<MyCardModel>> getMyCardsByUid(String uid) async {
    return await _firebaseMyCardService.getMyCardsByUid(uid);
  }

  @override
  Future<void> deleteMyCard(String cardId) async {
    await _firebaseMyCardService.deleteMyCard(cardId);
  }
}

