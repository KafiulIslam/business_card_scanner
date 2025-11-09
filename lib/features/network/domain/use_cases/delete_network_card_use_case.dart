import 'package:business_card_scanner/features/network/domain/repositories/network_repository.dart';

class DeleteNetworkCardUseCase {
  final NetworkRepository _networkRepository;

  DeleteNetworkCardUseCase(this._networkRepository);

  Future<void> call(String cardId) async {
    await _networkRepository.deleteNetworkCard(cardId);
  }
}

