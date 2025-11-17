import '../repositories/signed_document_repository.dart';

class DeleteSignedDocumentUseCase {
  final SignedDocumentRepository _repository;

  DeleteSignedDocumentUseCase(this._repository);

  Future<void> call({
    required String documentId,
    required String pdfUrl,
  }) {
    return _repository.deleteSignedDocument(
      documentId: documentId,
      pdfUrl: pdfUrl,
    );
  }
}

