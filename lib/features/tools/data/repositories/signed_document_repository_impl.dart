import '../../domain/entities/signed_document_model.dart';
import '../../domain/repositories/signed_document_repository.dart';
import '../services/firebase_signed_docs_service.dart';

class SignedDocumentRepositoryImpl implements SignedDocumentRepository {
  final FirebaseSignedDocsService _service;

  SignedDocumentRepositoryImpl(this._service);

  @override
  Future<List<SignedDocumentModel>> getSignedDocuments(String uid) {
    return _service.getSignedDocuments(uid);
  }

  @override
  Future<void> deleteSignedDocument({
    required String documentId,
    required String pdfUrl,
  }) {
    return _service.deleteSignedDocument(
      documentId: documentId,
      pdfUrl: pdfUrl,
    );
  }
}

