import 'dart:io';

import 'package:bloc/bloc.dart';

import '../../domain/use_cases/get_pdf_documents_use_case.dart';
import '../../domain/use_cases/upload_pdf_document_use_case.dart';
import 'convert_pdf_state.dart';

class ConvertPdfCubit extends Cubit<ConvertPdfState> {
  final GetPdfDocumentsUseCase _getPdfDocumentsUseCase;
  final UploadPdfDocumentUseCase _uploadPdfDocumentUseCase;

  ConvertPdfCubit(
    this._getPdfDocumentsUseCase,
    this._uploadPdfDocumentUseCase,
  ) : super(ConvertPdfState.initial());

  Future<void> fetchPdfDocuments(String uid) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final items = await _getPdfDocumentsUseCase(uid);
      emit(state.copyWith(isLoading: false, items: items));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> uploadPdf({
    required File pdfFile,
    required String title,
    required String uid,
  }) async {
    emit(state.copyWith(isUploading: true, clearError: true));
    try {
      await _uploadPdfDocumentUseCase(pdfFile: pdfFile, title: title);
      final items = await _getPdfDocumentsUseCase(uid);
      emit(state.copyWith(isUploading: false, items: items));
    } catch (e) {
      emit(state.copyWith(isUploading: false, error: e.toString()));
      rethrow;
    }
  }
}
