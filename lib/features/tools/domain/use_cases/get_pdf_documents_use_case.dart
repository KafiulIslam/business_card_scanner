import '../entities/pdf_document_model.dart';
import '../repositories/pdf_repository.dart';

class GetPdfDocumentsUseCase {
  final PdfRepository _repository;

  GetPdfDocumentsUseCase(this._repository);

  Future<List<PdfDocumentModel>> call(String uid) {
    return _repository.getPdfDocumentsByUid(uid);
  }
}
