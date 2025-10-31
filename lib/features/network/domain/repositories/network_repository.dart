import 'package:business_card_scanner/features/network/domain/entities/network_card.dart';

abstract class NetworkRepository {
  Future<void> saveNetworkCard(NetworkCard card);
  Future<List<NetworkCard>> getNetworkCardsByUid(String uid);
}

