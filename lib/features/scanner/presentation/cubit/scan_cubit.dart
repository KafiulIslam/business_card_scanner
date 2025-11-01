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

    // Email pattern
    final emailReg = RegExp(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}");
    final email = emailReg.firstMatch(fullText)?.group(0);

    // Phone pattern
    final phoneReg = RegExp(
        r"(?:(?:\+?\d{1,3}[\s-]?)?(?:\(\d{2,4}\)[\s-]?)?|\b)\d{3,4}[\s-]?\d{3}[\s-]?\d{3,4}\b");
    final phone = phoneReg.firstMatch(fullText)?.group(0);

    // Website pattern
    final webReg = RegExp(
        r"\b(?:https?:\/\/)?(?:www\.)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b");
    final website = webReg.firstMatch(fullText)?.group(0);

    // Job title keywords
    final jobTitleKeywords = [
      'manager', 'director', 'ceo', 'cto', 'cfo', 'president', 'vp', 'vice president',
      'senior', 'junior', 'lead', 'head', 'chief', 'executive', 'officer', 'coordinator',
      'specialist', 'analyst', 'engineer', 'developer', 'designer', 'consultant',
      'administrator', 'supervisor', 'assistant', 'representative', 'associate',
      'consultant', 'advisor', 'architect', 'technician', 'technologist'
    ];

    // Company indicators
    final companyIndicators = [
      'inc', 'inc.', 'llc', 'llc.', 'corp', 'corp.', 'ltd', 'ltd.', 'limited',
      'company', 'co', 'co.', 'enterprises', 'group', 'solutions', 'systems',
      'technologies', 'tech', 'services', 'international'
    ];

    // Address pattern (number + street name or city, state format)
    final addressReg = RegExp(
        r'\d+\s+[A-Za-z\s]+(?:Street|St|Avenue|Ave|Road|Rd|Boulevard|Blvd|Drive|Dr|Lane|Ln|Court|Ct|Way|Place|Pl)[,\s]*(?:[A-Za-z\s]+)?[,\s]*(?:[A-Za-z]+)?',
        caseSensitive: false);

    // Alternative address pattern (city, state/country)
    final cityStateReg = RegExp(
        r'[A-Z][a-zA-Z\s]+,\s*(?:[A-Z]{2}|[A-Za-z\s]+)',
        caseSensitive: true);

    String? name;
    String? jobTitle;
    String? company;
    String? address;

    // Extract name (first line that doesn't match other patterns)
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

    // Extract job title (look for lines with job title keywords)
    for (final l in lines) {
      final lowerLine = l.toLowerCase();
      // Skip if it's name, email, phone, website
      if (name != null && l.contains(name)) continue;
      if (email != null && l.contains(email)) continue;
      if (phone != null && l.contains(phone)) continue;
      if (website != null && l.contains(website)) continue;

      // Check if line contains job title keywords
      for (final keyword in jobTitleKeywords) {
        if (lowerLine.contains(keyword)) {
          jobTitle = l;
          break;
        }
      }
      if (jobTitle != null) break;
    }

    // Extract company (look for lines with company indicators or standalone capitalized line)
    for (final l in lines) {
      final lowerLine = l.toLowerCase();
      // Skip if it's name, job title, email, phone, website
      if (name != null && l.contains(name)) continue;
      if (jobTitle != null && l.contains(jobTitle)) continue;
      if (email != null && l.contains(email)) continue;
      if (phone != null && l.contains(phone)) continue;
      if (website != null && l.contains(website)) continue;

      // Check for company indicators
      for (final indicator in companyIndicators) {
        if (lowerLine.contains(indicator)) {
          company = l;
          break;
        }
      }

      // If no indicator found but line is capitalized and reasonable length, might be company
      if (company == null && l.length > 3 && l.length < 50) {
        final words = l.split(' ');
        if (words.length <= 4 && words.every((w) => w.isEmpty || w[0] == w[0].toUpperCase())) {
          // Potential company name (all words start with capital)
          company = l;
        }
      }
      if (company != null) break;
    }

    // Extract address
    final addressMatch = addressReg.firstMatch(fullText);
    if (addressMatch != null) {
      address = addressMatch.group(0)?.trim();
    } else {
      // Try city, state pattern
      final cityStateMatch = cityStateReg.firstMatch(fullText);
      if (cityStateMatch != null) {
        // Look for line containing city, state that's not already extracted
        for (final l in lines) {
          if (cityStateMatch.group(0) != null && l.contains(cityStateMatch.group(0)!)) {
            // Check if this line looks like an address (not email, phone, etc)
            if (email == null || !l.contains(email)) {
              if (phone == null || !l.contains(phone)) {
                if (website == null || !l.contains(website)) {
                  address = l;
                  break;
                }
              }
            }
          }
        }
      }
    }

    // Clean up extracted values
    if (name != null) name = name.trim();
    if (jobTitle != null) jobTitle = jobTitle.trim();
    if (company != null) company = company.trim();
    if (address != null) address = address.trim();

    return {
      'name': name,
      'jobTitle': jobTitle,
      'company': company,
      'email': email,
      'phone': phone,
      'website': website,
      'address': address,
    };
  }
}