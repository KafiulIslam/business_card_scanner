import 'package:business_card_scanner/features/network/domain/entities/network_card.dart';
import 'package:business_card_scanner/features/network/domain/repositories/network_repository.dart';

class SaveNetworkCardUseCase {
  final NetworkRepository _networkRepository;

  SaveNetworkCardUseCase(this._networkRepository);

  Future<void> call(NetworkCard card) async {
    await _networkRepository.saveNetworkCard(card);
  }
}

