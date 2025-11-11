import '../repositories/image_to_text_repository.dart';

class DeleteImageToTextUseCase {
  final ImageToTextRepository _repository;

  DeleteImageToTextUseCase(this._repository);

  Future<void> call(String documentId) async {
    await _repository.deleteImageToText(documentId);
  }
}
