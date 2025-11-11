import 'package:cloud_firestore/cloud_firestore.dart';

class PdfDocumentModel {
  final String? documentId;
  final String title;
  final String fileUrl;
  final DateTime? createdAt;
  final String uid;

  PdfDocumentModel({
    required this.documentId,
    required this.title,
    required this.fileUrl,
    required this.createdAt,
    required this.uid,
  });

  factory PdfDocumentModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime? createdAt;
    final createdAtRaw = map['created_at'];
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is DateTime) {
      createdAt = createdAtRaw;
    }

    return PdfDocumentModel(
      documentId: id,
      title: map['title'] as String? ?? 'Untitled PDF',
      fileUrl: map['pdf_url'] as String? ?? '',
      createdAt: createdAt,
      uid: map['uid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'pdf_url': fileUrl,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'uid': uid,
    };
  }
}
