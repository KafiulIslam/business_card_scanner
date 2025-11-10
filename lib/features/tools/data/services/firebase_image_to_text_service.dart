import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class FirebaseImageToTextService {
  final FirebaseFirestore _firestore;
  final fb.FirebaseAuth _auth;

  FirebaseImageToTextService({
    FirebaseFirestore? firestore,
    fb.FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? fb.FirebaseAuth.instance;

  Future<void> saveImageToText({
    required String imageUrl,
    required String scannedText,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Generate document ID
      final documentId = DateTime.now().millisecondsSinceEpoch.toString();

      // Prepare data
      final data = {
        'image_url': imageUrl,
        'scanned_text': scannedText,
        'uid': user.uid,
        'created_at': Timestamp.fromDate(DateTime.now()),
      };

      // Save to Firestore
      await _firestore
          .collection('image_to_text')
          .doc(documentId)
          .set(data);
    } catch (e) {
      throw Exception('Failed to save image to text: ${e.toString()}');
    }
  }
}

