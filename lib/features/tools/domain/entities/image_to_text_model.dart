import 'package:cloud_firestore/cloud_firestore.dart';

class ImageToTextModel {
  final String? documentId;
  final String? imageUrl;
  final String? title;
  final String? scannedText;
  final String? uid;
  final DateTime? createdAt;

  ImageToTextModel({
    this.documentId,
    this.imageUrl,
    this.title,
    this.scannedText,
    this.uid,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (documentId != null) map['documentId'] = documentId;
    if (imageUrl != null) map['image_url'] = imageUrl;
    if (title != null) map['title'] = title;
    if (scannedText != null) map['scanned_text'] = scannedText;
    if (uid != null) map['uid'] = uid;
    if (createdAt != null) {
      map['created_at'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }

  factory ImageToTextModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ImageToTextModel(
      documentId: documentId,
      imageUrl: map['image_url'] as String?,
      title: map['title'] as String?,
      scannedText: map['scanned_text'] as String?,
      uid: map['uid'] as String?,
      createdAt: map['created_at'] != null
          ? (map['created_at'] as Timestamp).toDate()
          : null,
    );
  }
}

