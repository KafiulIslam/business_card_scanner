import 'dart:io';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/scan_result_data.dart';
import 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(ScanState.initial());

  TextRecognizer? _textRecognizer;

  // ========= Lifecycle =========

  Future<void> initialize() async {
    try {
      emit(state.copyWith(isBusy: true, clearError: true));
      _textRecognizer ??= TextRecognizer(script: TextRecognitionScript.latin);

      // Pick back camera (fallback to first if not found)
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();

      // Optional: auto flash (adjust to your UX)
      try { await controller.setFlashMode(FlashMode.auto); } catch (_) {}

      emit(state.copyWith(cameraController: controller, isBusy: false));
    } catch (e) {
      emit(state.copyWith(isBusy: false, errorMessage: e.toString()));
    }
  }

  Future<void> handleLifecycle(AppLifecycleState appState) async {
    final controller = state.cameraController;
    if (controller == null) return;

    // On inactive/paused, release camera; on resumed, re-init.
    if (appState == AppLifecycleState.inactive ||
        appState == AppLifecycleState.paused) {
      await controller.dispose();
      emit(state.copyWith(cameraController: null));
    } else if (appState == AppLifecycleState.resumed) {
      await initialize();
    }
  }

  Future<void> disposeResources() async {
    try {
      await state.cameraController?.dispose();
      await _textRecognizer?.close();
      _textRecognizer = null;
    } catch (_) {}
  }

  // ========= Actions =========

  Future<void> scanFromCamera() async {
    final controller = state.cameraController;
    if (controller == null || state.isBusy) return;

    emit(state.copyWith(isBusy: true, clearError: true, clearResult: true));
    try {
      final xfile = await controller.takePicture();
      final recognized = await _recognize(InputImage.fromFilePath(xfile.path));

      emit(state.copyWith(
        isBusy: false,
        result: ScanResultData(
          rawText: recognized,
          extracted: _extractFields(recognized),
          imageFile: File(xfile.path),
        ),
      ));
    } catch (e) {
      emit(state.copyWith(isBusy: false, errorMessage: e.toString()));
    }
  }

  Future<void> scanFromGallery() async {
    if (state.isBusy) return;

    emit(state.copyWith(isBusy: true, clearError: true, clearResult: true));
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile == null) {
        emit(state.copyWith(isBusy: false));
        return;
      }

      final recognized = await _recognize(InputImage.fromFilePath(xFile.path));
      emit(state.copyWith(
        isBusy: false,
        result: ScanResultData(
          rawText: recognized,
          extracted: _extractFields(recognized),
          imageFile: File(xFile.path),
        ),
      ));
    } catch (e) {
      emit(state.copyWith(isBusy: false, errorMessage: e.toString()));
    }
  }

  Future<void> processImagePath(String path) async {
    if (state.isBusy) return;

    emit(state.copyWith(isBusy: true, clearError: true, clearResult: true));
    try {
      final recognized = await _recognize(InputImage.fromFilePath(path));
      emit(state.copyWith(
        isBusy: false,
        result: ScanResultData(
          rawText: recognized,
          extracted: _extractFields(recognized),
          imageFile: File(path),
        ),
      ));
    } catch (e) {
      emit(state.copyWith(isBusy: false, errorMessage: e.toString()));
    }
  }

  void clearResult() => emit(state.copyWith(clearResult: true));
  void clearError() => emit(state.copyWith(clearError: true));

  // ========= Helpers =========

  Future<String> _recognize(InputImage input) async {
    _textRecognizer ??= TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await _textRecognizer!.processImage(input);
    return recognizedText.text;
  }

  Map<String, String?> _extractFields(String text) {
    final lines = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final fullText = lines.join(' ');

    final emailReg = RegExp(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}");
    final phoneReg = RegExp(
        r"(?:(?:\+?\d{1,3}[\s-]?)?(?:\(\d{2,4}\)[\s-]?)?|\b)\d{3,4}[\s-]?\d{3}[\s-]?\d{3,4}\b");
    final webReg = RegExp(
        r"\b(?:https?:\/\/)?(?:www\.)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b");

    final email = emailReg.firstMatch(fullText)?.group(0);
    final phone = phoneReg.firstMatch(fullText)?.group(0);
    final website = webReg.firstMatch(fullText)?.group(0);

    String? name;
    for (final l in lines) {
      if (email != null && l.contains(email)) continue;
      if (phone != null && l.contains(phone)) continue;
      if (website != null && l.contains(website)) continue;
      if (l.toLowerCase().contains('address') ||
          l.toLowerCase().contains('tel')) continue;
      if (l.length > 2) {
        name = l;
        break;
      }
    }

    return {
      'name': name,
      'email': email,
      'phone': phone,
      'website': website,
    };
  }
}
