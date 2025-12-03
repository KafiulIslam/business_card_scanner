class WriteEmailState {
  final bool isLoading;
  final String? error;
  final String? generatedSubject;
  final String? generatedBody;

  const WriteEmailState({
    required this.isLoading,
    required this.error,
    required this.generatedSubject,
    required this.generatedBody,
  });

  factory WriteEmailState.initial() => const WriteEmailState(
        isLoading: false,
        error: null,
        generatedSubject: null,
        generatedBody: null,
      );

  WriteEmailState copyWith({
    bool? isLoading,
    String? error,
    String? generatedSubject,
    String? generatedBody,
    bool clearError = false,
    bool clearGeneratedEmail = false,
  }) {
    return WriteEmailState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      generatedSubject: clearGeneratedEmail
          ? null
          : (generatedSubject ?? this.generatedSubject),
      generatedBody:
          clearGeneratedEmail ? null : (generatedBody ?? this.generatedBody),
    );
  }
}

