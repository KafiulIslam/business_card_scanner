import 'dart:io';

import 'package:flutter/material.dart';

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
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(
            imageFile,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
