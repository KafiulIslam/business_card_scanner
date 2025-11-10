import 'dart:io';
import 'package:business_card_scanner/core/routes/routes.dart';
import 'package:business_card_scanner/core/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScanDocumentsScreen extends StatelessWidget {
  final File imageFile;

  const ScanDocumentsScreen({
    super.key,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Documents'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
        child: PrimaryButton(
          onTap: () {
            context.push(Routes.scannedToText, extra: imageFile);
          },
          buttonTitle: 'Scan',
        ),
      ),
    );
  }
}

