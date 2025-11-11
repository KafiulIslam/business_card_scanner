import 'dart:io';

import '../entities/pdf_document_model.dart';

abstract class PdfRepository {
  Future<void> uploadPdf({required File pdfFile, required String title});
  Future<List<PdfDocumentModel>> getPdfDocumentsByUid(String uid);
}
