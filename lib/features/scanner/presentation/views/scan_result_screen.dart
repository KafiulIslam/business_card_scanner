import 'dart:io';
import 'package:flutter/material.dart';

class ScanResultScreen extends StatelessWidget {
  final String rawText;
  final Map<String, String?> extracted;
  final File? imageFile;

  const ScanResultScreen({super.key, required this.rawText, required this.extracted, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanned Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(imageFile!, height: 180, fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          _tile('Name', extracted['name']),
          _tile('Email', extracted['email']),
          _tile('Phone', extracted['phone']),
          _tile('Website', extracted['website']),
          const SizedBox(height: 12),
          const Text('All Extracted Text', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(rawText),
          )
        ],
      ),
    );
  }

  Widget _tile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 92, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Expanded(child: Text(value?.isNotEmpty == true ? value! : '-')),
        ],
      ),
    );
  }
}


