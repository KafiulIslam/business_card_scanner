import '../../domain/entities/image_to_text_model.dart';
import '../../domain/repositories/image_to_text_repository.dart';
import '../services/firebase_image_to_text_service.dart';

class ImageToTextRepositoryImpl implements ImageToTextRepository {
  final FirebaseImageToTextService _firebaseImageToTextService;

  ImageToTextRepositoryImpl(this._firebaseImageToTextService);

  @override
  Future<void> saveImageToText({
    required String imageUrl,
    required String scannedText,
  }) async {
    await _firebaseImageToTextService.saveImageToText(
      imageUrl: imageUrl,
      scannedText: scannedText,
    );
  }

  @override
  Future<List<ImageToTextModel>> getImageToTextListByUid(String uid) async {
    return await _firebaseImageToTextService.getImageToTextListByUid(uid);
  }
}

