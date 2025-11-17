import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entities/signed_document_model.dart';

class FirebaseSignedDocsService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirebaseSignedDocsService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Future<List<SignedDocumentModel>> getSignedDocuments(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;
      try {
        snapshot = await _firestore
            .collection('signed_docs')
            .where('uid', isEqualTo: uid)
            .orderBy('created_at', descending: true)
            .get();
      } catch (_) {
        snapshot = await _firestore
            .collection('signed_docs')
            .where('uid', isEqualTo: uid)
            .get();
      }

      final documents = snapshot.docs
          .map(
            (doc) => SignedDocumentModel.fromMap(doc.data(), doc.id),
          )
          .toList();

      documents.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return documents;
    } catch (e) {
      throw Exception('Failed to load signed documents: ${e.toString()}');
    }
  }

  Future<void> deleteSignedDocument({
    required String documentId,
    required String pdfUrl,
  }) async {
    try {
      if (pdfUrl.isNotEmpty) {
        final ref = _storage.refFromURL(pdfUrl);
        await ref.delete();
      }
    } catch (_) {
      // ignore storage delete failures but continue to delete metadata
    } finally {
      await _firestore.collection('signed_docs').doc(documentId).delete();
    }
  }
}

