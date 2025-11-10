import '../repositories/image_to_text_repository.dart';

class UpdateImageToTextUseCase {
  final ImageToTextRepository _repository;

  UpdateImageToTextUseCase(this._repository);

  Future<void> call({
    required String documentId,
    required String title,
    required String scannedText,
  }) async {
    await _repository.updateImageToText(
      documentId: documentId,
      title: title,
      scannedText: scannedText,
    );
  }
}
