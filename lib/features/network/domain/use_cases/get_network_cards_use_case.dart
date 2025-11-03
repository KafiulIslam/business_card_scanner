import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:business_card_scanner/features/network/domain/repositories/network_repository.dart';

class GetNetworkCardsUseCase {
  final NetworkRepository _networkRepository;

  GetNetworkCardsUseCase(this._networkRepository);

  Future<List<NetworkModel>> call(String uid) async {
    return await _networkRepository.getNetworkCardsByUid(uid);
  }
}

