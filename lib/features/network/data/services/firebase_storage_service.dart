import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class FirebaseStorageService {
  final FirebaseStorage _storage;
  final fb.FirebaseAuth _auth;

  FirebaseStorageService({
    FirebaseStorage? storage,
    fb.FirebaseAuth? auth,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? fb.FirebaseAuth.instance;

  Future<String> uploadCardImage(File imageFile, String cardId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final ref = _storage.ref().child('network_cards').child(user.uid).child('$cardId.jpg');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl.toString();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}

