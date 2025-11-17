import 'package:cloud_firestore/cloud_firestore.dart';

class SignedDocumentModel {
  final String? documentId;
  final String title;
  final String pdfUrl;
  final String uid;
  final DateTime? createdAt;

  SignedDocumentModel({
    required this.documentId,
    required this.title,
    required this.pdfUrl,
    required this.uid,
    required this.createdAt,
  });

  factory SignedDocumentModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    DateTime? createdAt;
    final rawCreatedAt = map['created_at'];
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is DateTime) {
      createdAt = rawCreatedAt;
    }

    return SignedDocumentModel(
      documentId: id,
      title: (map['title'] as String?)?.trim() ?? 'Untitled document',
      pdfUrl: map['pdf_url'] as String? ?? '',
      uid: map['uid'] as String? ?? '',
      createdAt: createdAt,
    );
  }
}

