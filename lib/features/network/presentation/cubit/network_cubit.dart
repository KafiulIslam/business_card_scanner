import 'package:bloc/bloc.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_card.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/save_network_card_use_case.dart';
import 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final SaveNetworkCardUseCase _saveNetworkCardUseCase;

  NetworkCubit(this._saveNetworkCardUseCase) : super(NetworkState.initial());

  Future<void> saveNetworkCard(NetworkCard card) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _saveNetworkCardUseCase(card);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void reset() {
    emit(NetworkState.initial());
  }
}

