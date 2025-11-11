import '../../domain/entities/pdf_document_model.dart';

class ConvertPdfState {
  final bool isLoading;
  final bool isUploading;
  final String? error;
  final List<PdfDocumentModel> items;

  const ConvertPdfState({
    required this.isLoading,
    required this.isUploading,
    required this.error,
    required this.items,
  });

  factory ConvertPdfState.initial() => const ConvertPdfState(
        isLoading: false,
        isUploading: false,
        error: null,
        items: [],
      );

  ConvertPdfState copyWith({
    bool? isLoading,
    bool? isUploading,
    String? error,
    List<PdfDocumentModel>? items,
    bool clearError = false,
  }) {
    return ConvertPdfState(
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      error: clearError ? null : (error ?? this.error),
      items: items ?? this.items,
    );
  }
}
