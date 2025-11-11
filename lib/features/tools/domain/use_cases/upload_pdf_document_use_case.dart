import 'dart:io';

import '../repositories/pdf_repository.dart';

class UploadPdfDocumentUseCase {
  final PdfRepository _repository;

  UploadPdfDocumentUseCase(this._repository);

  Future<void> call({required File pdfFile, required String title}) {
    return _repository.uploadPdf(pdfFile: pdfFile, title: title);
  }
}
