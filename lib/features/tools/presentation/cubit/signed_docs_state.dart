import '../../domain/entities/signed_document_model.dart';

class SignedDocsState {
  final bool isLoading;
  final List<SignedDocumentModel> documents;
  final String? error;

  const SignedDocsState({
    required this.isLoading,
    required this.documents,
    this.error,
  });

  factory SignedDocsState.initial() {
    return const SignedDocsState(
      isLoading: false,
      documents: [],
      error: null,
    );
  }

  SignedDocsState copyWith({
    bool? isLoading,
    List<SignedDocumentModel>? documents,
    String? error,
  }) {
    return SignedDocsState(
      isLoading: isLoading ?? this.isLoading,
      documents: documents ?? this.documents,
      error: error,
    );
  }
}

