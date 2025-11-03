import 'dart:io';

class ScanResultData {
  final String rawText;
  final Map<String, String?> extracted;
  final File? imageFile;
  final bool isCameraScanned;

  const ScanResultData({
    required this.rawText,
    required this.extracted,
    this.imageFile,
    this.isCameraScanned = false,
  });
}