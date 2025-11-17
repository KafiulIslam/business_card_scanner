import '../entities/signed_document_model.dart';
import '../repositories/signed_document_repository.dart';

class GetSignedDocumentsUseCase {
  final SignedDocumentRepository _repository;

  GetSignedDocumentsUseCase(this._repository);

  Future<List<SignedDocumentModel>> call(String uid) {
    return _repository.getSignedDocuments(uid);
  }
}

