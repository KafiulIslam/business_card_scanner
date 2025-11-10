import 'dart:io';
import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/theme/app_dimensions.dart';
import 'package:business_card_scanner/core/theme/app_text_style.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:business_card_scanner/core/widgets/custom_loader.dart';
import 'package:business_card_scanner/core/widgets/error_widget.dart';
import 'package:business_card_scanner/core/widgets/popup_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScannedToTextScreen extends StatefulWidget {
  final File imageFile;

  const ScannedToTextScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<ScannedToTextScreen> createState() => _ScannedToTextScreenState();
}

class _ScannedToTextScreenState extends State<ScannedToTextScreen> {
  TextRecognizer? _textRecognizer;
  String _recognizedText = '';
  bool _isProcessing = true;
  String? _errorMessage;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _initializeAndRecognize();
  }

  Future<void> _initializeAndRecognize() async {
    try {
      _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final inputImage = InputImage.fromFilePath(widget.imageFile.path);
      final recognizedText = await _textRecognizer!.processImage(inputImage);

      if (mounted) {
        setState(() {
          _recognizedText = recognizedText.text;
          _textController.text = recognizedText.text;
          _isProcessing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _textRecognizer?.close();
    _textController.dispose();
    super.dispose();
  }

  String get _currentText => _textController.text;

  Future<void> _copyText() async {
    final text = _currentText;
    if (text.isEmpty) {
      if (mounted) {
        CustomSnack.warning('No text to copy', context);
      }
      return;
    }

    try {
      final service = context.read<ExternalAppService>();
      service.copyToClipboard(text);
      if (mounted) {
        CustomSnack.success('Text copied to clipboard', context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to copy: ${e.toString()}', context);
      }
    }
  }

  Future<void> _shareText() async {
    final text = _currentText;
    if (text.isEmpty) {
      if (mounted) {
        CustomSnack.warning('No text to share', context);
      }
      return;
    }

    try {
      final service = context.read<ExternalAppService>();
      await service.shareContent(text);
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to share: ${e.toString()}', context);
      }
    }
  }

  Future<void> _exportText() async {
    final text = _currentText;
    if (text.isEmpty) {
      if (mounted) {
        CustomSnack.warning('No text to export', context);
      }
      return;
    }

    try {
      final service = context.read<ExternalAppService>();
      await service.exportTextToFile(text);
      if (mounted) {
        CustomSnack.success('Text exported successfully', context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnack.warning('Failed to export: ${e.toString()}', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned To Text'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton(
              icon: const Icon(Icons.more_horiz),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem(
                  onTap: () => _copyText(),
                  child: const CustomPopupItem(icon: Icons.copy, title: 'Copy'),
                ),
                PopupMenuItem(
                    onTap: () => _shareText(),
                    child: const CustomPopupItem(
                        icon: Icons.share_outlined, title: 'Share')),
                PopupMenuItem(
                    onTap: () => _exportText(),
                    child: const CustomPopupItem(
                        icon: Icons.download_outlined, title: 'Export')),
              ],
            ),
          )
        ],
      ),
      body: _isProcessing
          ? const CustomLoader()
          : _errorMessage != null
              ? CustomErrorWidget(
                  errorTitle: 'Error processing image',
                  errorMessage: _errorMessage ?? '')
              : SingleChildScrollView(
                  padding: EdgeInsets.all(AppDimensions.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preview Section
                      Text(
                        'Preview',
                        style: AppTextStyles.headline4,
                      ),
                      Gap(AppDimensions.spacing12),
                      Container(
                        height: MediaQuery.sizeOf(context).height / 3,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppDimensions.radius12),
                            topRight: Radius.circular(AppDimensions.radius12),
                            bottomRight:
                                Radius.circular(AppDimensions.radius20),
                            bottomLeft: Radius.circular(AppDimensions.radius12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppDimensions.radius12),
                            topRight: Radius.circular(AppDimensions.radius12),
                            bottomRight:
                                Radius.circular(AppDimensions.radius20),
                            bottomLeft: Radius.circular(AppDimensions.radius12),
                          ),
                          child: Image.file(
                            widget.imageFile,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Gap(AppDimensions.spacing24),
                      // Result Section
                      Text(
                        'Result',
                        style: AppTextStyles.headline4,
                      ),
                      Gap(AppDimensions.spacing12),
                      _recognizedText.isEmpty
                          ? Text(
                              'No text detected',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.gray500,
                              ),
                            )
                          : TextField(
                              controller: _textController,
                              maxLines: null,
                              minLines: 8,
                              style: AppTextStyles.bodyMedium,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _recognizedText = value;
                                });
                              },
                            ),
                      Gap(AppDimensions.spacing48), // Space for bottom bar
                    ],
                  ),
                ),
    );
  }
}
