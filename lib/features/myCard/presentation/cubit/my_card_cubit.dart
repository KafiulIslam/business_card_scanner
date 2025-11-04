import 'package:bloc/bloc.dart';
import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';
import 'package:business_card_scanner/features/myCard/domain/use_cases/save_my_card_use_case.dart';
import 'package:business_card_scanner/features/myCard/domain/use_cases/get_my_cards_use_case.dart';
import 'my_card_state.dart';

class MyCardCubit extends Cubit<MyCardState> {
  final SaveMyCardUseCase _saveMyCardUseCase;
  final GetMyCardsUseCase _getMyCardsUseCase;

  MyCardCubit(
    this._saveMyCardUseCase,
    this._getMyCardsUseCase,
  ) : super(MyCardState.initial());

  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading, error: null, isSuccess: false));
  }

  Future<void> saveMyCard(MyCardModel card, {bool setLoadingState = true}) async {
    if (setLoadingState) {
      emit(state.copyWith(isLoading: true, error: null, isSuccess: false));
    }
    try {
      await _saveMyCardUseCase(card);
      emit(state.copyWith(isLoading: false, isSuccess: true, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString(), isSuccess: false));
    }
  }

  Future<void> fetchMyCards(String uid) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final cards = await _getMyCardsUseCase(uid);
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
    emit(MyCardState.initial());
  }
}

