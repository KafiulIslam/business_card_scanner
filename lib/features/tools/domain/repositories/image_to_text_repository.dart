import '../entities/image_to_text_model.dart';

abstract class ImageToTextRepository {
  Future<void> saveImageToText({
    required String imageUrl,
    required String scannedText,
  });
  Future<List<ImageToTextModel>> getImageToTextListByUid(String uid);
}

