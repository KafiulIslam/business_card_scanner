import '../../domain/entities/image_to_text_model.dart';
import '../../domain/repositories/image_to_text_repository.dart';
import '../services/firebase_image_to_text_service.dart';

class ImageToTextRepositoryImpl implements ImageToTextRepository {
  final FirebaseImageToTextService _firebaseImageToTextService;

  ImageToTextRepositoryImpl(this._firebaseImageToTextService);

  @override
  Future<void> saveImageToText({
    required String imageUrl,
    required String title,
    required String scannedText,
  }) async {
    await _firebaseImageToTextService.saveImageToText(
      imageUrl: imageUrl,
      title: title,
      scannedText: scannedText,
    );
  }

  @override
  Future<void> updateImageToText({
    required String documentId,
    required String title,
    required String scannedText,
  }) async {
    await _firebaseImageToTextService.updateImageToText(
      documentId: documentId,
      title: title,
      scannedText: scannedText,
    );
  }

  @override
  Future<void> deleteImageToText(String documentId) async {
    await _firebaseImageToTextService.deleteImageToText(documentId);
  }

  @override
  Future<List<ImageToTextModel>> getImageToTextListByUid(String uid) async {
    return await _firebaseImageToTextService.getImageToTextListByUid(uid);
  }
}

