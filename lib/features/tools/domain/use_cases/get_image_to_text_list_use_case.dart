import '../entities/image_to_text_model.dart';
import '../repositories/image_to_text_repository.dart';

class GetImageToTextListUseCase {
  final ImageToTextRepository _imageToTextRepository;

  GetImageToTextListUseCase(this._imageToTextRepository);

  Future<List<ImageToTextModel>> call(String uid) async {
    return await _imageToTextRepository.getImageToTextListByUid(uid);
  }
}

