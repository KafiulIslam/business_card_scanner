import 'package:camera/camera.dart';

import '../../domain/entities/scan_result_data.dart';

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
