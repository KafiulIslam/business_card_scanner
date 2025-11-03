import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:business_card_scanner/features/network/domain/repositories/network_repository.dart';
import '../services/firebase_network_service.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  final FirebaseNetworkService _firebaseNetworkService;

  NetworkRepositoryImpl(this._firebaseNetworkService);

  @override
  Future<void> saveNetworkCard(NetworkModel card) async {
    await _firebaseNetworkService.saveNetworkCard(card);
  }

  @override
  Future<List<NetworkModel>> getNetworkCardsByUid(String uid) async {
    return await _firebaseNetworkService.getNetworkCardsByUid(uid);
  }
}

