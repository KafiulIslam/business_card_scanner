import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/image_to_text_model.dart';

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

  Future<List<ImageToTextModel>> getImageToTextListByUid(String uid) async {
    try {
      QuerySnapshot snapshot;
      try {
        // Try with orderBy first
        snapshot = await _firestore
            .collection('image_to_text')
            .where('uid', isEqualTo: uid)
            .orderBy('created_at', descending: true)
            .get();
      } catch (e) {
        // If orderBy fails (index not created), fetch without orderBy
        snapshot = await _firestore
            .collection('image_to_text')
            .where('uid', isEqualTo: uid)
            .get();
      }

      final items = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ImageToTextModel.fromMap(data, doc.id);
          })
          .toList();

      // Sort manually if orderBy wasn't used
      items.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return items;
    } catch (e) {
      throw Exception('Failed to fetch image to text list: ${e.toString()}');
    }
  }
}

