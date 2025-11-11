import 'dart:io';

import '../../domain/entities/pdf_document_model.dart';
import '../../domain/repositories/pdf_repository.dart';
import '../services/firebase_pdf_service.dart';

class PdfRepositoryImpl implements PdfRepository {
  final FirebasePdfService _firebasePdfService;

  PdfRepositoryImpl(this._firebasePdfService);

  @override
  Future<void> uploadPdf({required File pdfFile, required String title}) async {
    await _firebasePdfService.uploadPdf(pdfFile: pdfFile, title: title);
  }

  @override
  Future<List<PdfDocumentModel>> getPdfDocumentsByUid(String uid) async {
    return _firebasePdfService.getPdfDocumentsByUid(uid);
  }
}
