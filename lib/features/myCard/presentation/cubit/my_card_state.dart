import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';

class MyCardState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final List<MyCardModel> cards;

  MyCardState({
    required this.isLoading,
    required this.isSuccess,
    required this.error,
    required this.cards,
  });

  factory MyCardState.initial() => MyCardState(
        isLoading: false,
        isSuccess: false,
        error: null,
        cards: [],
      );

  MyCardState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    List<MyCardModel>? cards,
    bool clearError = false,
  }) {
    return MyCardState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : (error ?? this.error),
      cards: cards ?? this.cards,
    );
  }
}

