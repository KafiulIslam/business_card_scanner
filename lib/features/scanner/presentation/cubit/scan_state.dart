import 'dart:io';
import 'package:camera/camera.dart';

class ScanResultData {
  final String rawText;
  final Map<String, String?> extracted;
  final File? imageFile;

  const ScanResultData({required this.rawText, required this.extracted, this.imageFile});
}

class ScanState {
  final CameraController? cameraController;
  final bool isBusy;
  final String? errorMessage;
  final ScanResultData? result;

  const ScanState({
    required this.cameraController,
    required this.isBusy,
    required this.errorMessage,
    required this.result,
  });

  factory ScanState.initial() => const ScanState(
        cameraController: null,
        isBusy: false,
        errorMessage: null,
        result: null,
      );

  ScanState copyWith({
    CameraController? cameraController,
    bool? isBusy,
    String? errorMessage,
    bool clearError = false,
    ScanResultData? result,
    bool clearResult = false,
  }) {
    return ScanState(
      cameraController: cameraController ?? this.cameraController,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      result: clearResult ? null : (result ?? this.result),
    );
  }
}


