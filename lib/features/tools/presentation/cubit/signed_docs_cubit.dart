import 'package:bloc/bloc.dart';

import '../../domain/entities/signed_document_model.dart';
import '../../domain/use_cases/delete_signed_document_use_case.dart';
import '../../domain/use_cases/get_signed_documents_use_case.dart';
import 'signed_docs_state.dart';

class SignedDocsCubit extends Cubit<SignedDocsState> {
  final GetSignedDocumentsUseCase _getSignedDocumentsUseCase;
  final DeleteSignedDocumentUseCase _deleteSignedDocumentUseCase;

  SignedDocsCubit(
    this._getSignedDocumentsUseCase,
    this._deleteSignedDocumentUseCase,
  ) : super(SignedDocsState.initial());

  Future<void> fetchSignedDocuments(String uid) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final docs = await _getSignedDocumentsUseCase(uid);
      emit(
        state.copyWith(
          isLoading: false,
          documents: docs,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  void reset() {
    emit(SignedDocsState.initial());
  }

  Future<void> deleteSignedDocument(SignedDocumentModel document) async {
    final docId = document.documentId;
    if (docId == null || docId.isEmpty) {
      emit(state.copyWith(error: 'Document reference is missing.'));
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _deleteSignedDocumentUseCase(
        documentId: docId,
        pdfUrl: document.pdfUrl,
      );
      final docs = await _getSignedDocumentsUseCase(document.uid);
      emit(
        state.copyWith(
          isLoading: false,
          documents: docs,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }
}

