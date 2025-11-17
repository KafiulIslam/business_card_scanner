import '../entities/signed_document_model.dart';

abstract class SignedDocumentRepository {
  Future<List<SignedDocumentModel>> getSignedDocuments(String uid);
  Future<void> deleteSignedDocument({
    required String documentId,
    required String pdfUrl,
  });
}

