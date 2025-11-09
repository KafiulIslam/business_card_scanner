import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';

abstract class NetworkRepository {
  Future<void> saveNetworkCard(NetworkModel card);
  Future<List<NetworkModel>> getNetworkCardsByUid(String uid);
  Future<void> deleteNetworkCard(String cardId);
}

