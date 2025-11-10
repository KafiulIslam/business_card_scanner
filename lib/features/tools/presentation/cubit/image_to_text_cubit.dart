import 'package:bloc/bloc.dart';
import '../../domain/use_cases/get_image_to_text_list_use_case.dart';
import 'image_to_text_state.dart';

class ImageToTextCubit extends Cubit<ImageToTextState> {
  final GetImageToTextListUseCase _getImageToTextListUseCase;

  ImageToTextCubit(this._getImageToTextListUseCase)
      : super(ImageToTextState.initial());

  Future<void> fetchImageToTextList(String uid) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final items = await _getImageToTextListUseCase(uid);
      emit(state.copyWith(
        isLoading: false,
        items: items,
        isSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void reset() {
    emit(ImageToTextState.initial());
  }
}

