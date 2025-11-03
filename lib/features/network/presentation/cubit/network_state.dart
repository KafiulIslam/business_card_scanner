import 'package:business_card_scanner/features/network/domain/entities/network_model.dart';

class NetworkState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final List<NetworkModel> cards;

  NetworkState({
    required this.isLoading,
    required this.isSuccess,
    required this.error,
    required this.cards,
  });

  factory NetworkState.initial() => NetworkState(
        isLoading: false,
        isSuccess: false,
        error: null,
        cards: [],
      );

  NetworkState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    List<NetworkModel>? cards,
    bool clearError = false,
  }) {
    return NetworkState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : (error ?? this.error),
      cards: cards ?? this.cards,
    );
  }
}

