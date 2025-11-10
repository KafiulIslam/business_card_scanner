import '../../domain/entities/image_to_text_model.dart';

class ImageToTextState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final List<ImageToTextModel> items;

  ImageToTextState({
    required this.isLoading,
    required this.isSuccess,
    required this.error,
    required this.items,
  });

  factory ImageToTextState.initial() => ImageToTextState(
        isLoading: false,
        isSuccess: false,
        error: null,
        items: [],
      );

  ImageToTextState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    List<ImageToTextModel>? items,
    bool clearError = false,
  }) {
    return ImageToTextState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : (error ?? this.error),
      items: items ?? this.items,
    );
  }
}

