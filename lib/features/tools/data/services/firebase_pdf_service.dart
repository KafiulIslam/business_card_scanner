import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entities/pdf_document_model.dart';

class FirebasePdfService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final fb.FirebaseAuth _auth;

  FirebasePdfService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    fb.FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? fb.FirebaseAuth.instance;

  Future<void> uploadPdf({
    required File pdfFile,
    required String title,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storageRef = _storage
          .ref()
          .child('pdf_documents/${user.uid}/pdf_$timestamp.pdf');

      await storageRef.putFile(pdfFile);
      final downloadUrl = await storageRef.getDownloadURL();

      final documentData = {
        'title': title,
        'pdf_url': downloadUrl,
        'uid': user.uid,
        'created_at': Timestamp.fromDate(DateTime.now()),
      };

      await _firestore.collection('pdf_documents').add(documentData);
    } catch (e) {
      throw Exception('Failed to upload PDF: ${e.toString()}');
    }
  }

  Future<List<PdfDocumentModel>> getPdfDocumentsByUid(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;
      try {
        snapshot = await _firestore
            .collection('pdf_documents')
            .where('uid', isEqualTo: uid)
            .orderBy('created_at', descending: true)
            .get();
      } catch (e) {
        snapshot = await _firestore
            .collection('pdf_documents')
            .where('uid', isEqualTo: uid)
            .get();
      }

      final items = snapshot.docs
          .map((doc) {
            final data = doc.data();
            return PdfDocumentModel.fromMap(data, doc.id);
          })
          .toList();

      items.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return items;
    } catch (e) {
      throw Exception('Failed to fetch PDF documents: ${e.toString()}');
    }
  }
}
