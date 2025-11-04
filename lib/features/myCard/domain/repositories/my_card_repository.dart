import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';

abstract class MyCardRepository {
  Future<void> saveMyCard(MyCardModel card);
  Future<List<MyCardModel>> getMyCardsByUid(String uid);
}

