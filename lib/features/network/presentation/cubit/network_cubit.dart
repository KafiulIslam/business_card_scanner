import 'package:bloc/bloc.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/save_network_card_use_case.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/get_network_cards_use_case.dart';
import 'package:business_card_scanner/features/network/domain/use_cases/delete_network_card_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  final SaveNetworkCardUseCase _saveNetworkCardUseCase;
  final GetNetworkCardsUseCase _getNetworkCardsUseCase;
  final DeleteNetworkCardUseCase _deleteNetworkCardUseCase;

  NetworkCubit(
    this._saveNetworkCardUseCase,
    this._getNetworkCardsUseCase,
    this._deleteNetworkCardUseCase,
  ) : super(NetworkState.initial());

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading, error: null, isSuccess: false));
  }

  Future<void> saveNetworkCard(NetworkModel card, {bool setLoadingState = true}) async {
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

  Future<void> deleteNetworkCard(String cardId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _deleteNetworkCardUseCase(cardId);
      // Refresh the cards list after deletion
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final cards = await _getNetworkCardsUseCase(user.uid);
        emit(state.copyWith(
          isLoading: false,
          cards: cards,
          isSuccess: true,
          error: null,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          error: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString(), isSuccess: false));
    }
  }

  void reset() {
    emit(NetworkState.initial());
  }

  void clearFlags() {
    emit(state.copyWith(
      isSuccess: false,
      error: null,
      clearError: true,
    ));
  }
}

