class NetworkState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  NetworkState({
    required this.isLoading,
    required this.isSuccess,
    required this.error,
  });

  factory NetworkState.initial() => NetworkState(
        isLoading: false,
        isSuccess: false,
        error: null,
      );

  NetworkState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    bool clearError = false,
  }) {
    return NetworkState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

