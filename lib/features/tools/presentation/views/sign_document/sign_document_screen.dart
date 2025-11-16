import 'package:business_card_scanner/core/routes/routes.dart';
import 'package:business_card_scanner/core/services/external_app_service.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/core/utils/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignDocumentScreen extends StatefulWidget {
  const SignDocumentScreen({super.key});

  @override
  State<SignDocumentScreen> createState() => _SignDocumentScreenState();
}

class _SignDocumentScreenState extends State<SignDocumentScreen> {
  Future<void> _pickPdfFile() async {
    try {
      final externalAppService = context.read<ExternalAppService>();
      final pdfResult = await externalAppService.pickPdfFile();

      if (pdfResult == null || !mounted) {
        return;
      }

      // Navigate to SignCanvasScreen with the PDF file using go_router
      context.push(
        Routes.signCanvas,
        extra: {
          'documentTitle': pdfResult.fileName,
          'pdfFilePath': pdfResult.file.path,
        },
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnack.warning('Failed to pick PDF file: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Document'),
        backgroundColor: AppColors.scaffoldBG,
      ),
      body: const Center(child: Text('Sign Document')),

      floatingActionButton: FloatingActionButton(
        onPressed: _pickPdfFile,
        child: const Icon(Icons.note_alt_outlined),
      ),
    );
  }
}
