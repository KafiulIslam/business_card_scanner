import '../entities/image_to_text_model.dart';

abstract class ImageToTextRepository {
  Future<void> saveImageToText({
    required String imageUrl,
    required String title,
    required String scannedText,
  });
  Future<void> updateImageToText({
    required String documentId,
    required String title,
    required String scannedText,
  });
  Future<void> deleteImageToText(String documentId);
  Future<List<ImageToTextModel>> getImageToTextListByUid(String uid);
}

