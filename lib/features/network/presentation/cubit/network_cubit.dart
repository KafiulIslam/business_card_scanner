import 'package:bloc/bloc.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_card.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/save_network_card_use_case.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/get_network_cards_use_case.dart';
import 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final SaveNetworkCardUseCase _saveNetworkCardUseCase;
  final GetNetworkCardsUseCase _getNetworkCardsUseCase;

  NetworkCubit(
    this._saveNetworkCardUseCase,
    this._getNetworkCardsUseCase,
  ) : super(NetworkState.initial());

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading, error: null, isSuccess: false));
  }

  Future<void> saveNetworkCard(NetworkCard card, {bool setLoadingState = true}) async {
    if (setLoadingState) {
      emit(state.copyWith(isLoading: true, error: null, isSuccess: false));
    }
    try {
      await _saveNetworkCardUseCase(card);
      emit(state.copyWith(isLoading: false, isSuccess: true, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString(), isSuccess: false));
    }
  }

  Future<void> fetchNetworkCards(String uid) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final cards = await _getNetworkCardsUseCase(uid);
      emit(state.copyWith(
        isLoading: false,
        cards: cards,
        isSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void reset() {
    emit(NetworkState.initial());
  }
}

