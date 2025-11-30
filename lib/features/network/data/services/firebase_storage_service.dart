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
    if (!await imageFile.exists()) {
      throw Exception('Image file does not exist');
    }

    final fileSize = await imageFile.length();
    if (fileSize == 0) {
      throw Exception('Image file is empty');
    }

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Read file bytes and use putData (avoids file access issues)
    final imageBytes = await imageFile.readAsBytes();

    // Detect content type based on file extension
    final fileExtension = imageFile.path.toLowerCase().split('.').last;
    final contentType = fileExtension == 'png' ? 'image/png' : 'image/jpeg';
    final storageExtension = fileExtension == 'png' ? 'png' : 'jpg';

    // Upload to: network_cards/{userId}/{cardId}.{extension}
    final ref = _storage
        .ref()
        .child('network_cards')
        .child(user.uid)
        .child('$cardId.$storageExtension');

    final metadata = SettableMetadata(
      contentType: contentType,
      cacheControl: 'max-age=3600',
    );

    final snapshot = await ref.putData(imageBytes, metadata);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl.toString();
  }

  /// Updates an existing card image by uploading to the same path (overwrites old image)
  Future<String> updateCardImage(File imageFile, String cardId) async {
    if (!await imageFile.exists()) {
      throw Exception('Image file does not exist');
    }

    final fileSize = await imageFile.length();
    if (fileSize == 0) {
      throw Exception('Image file is empty');
    }

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Read file bytes and use putData (avoids file access issues)
    final imageBytes = await imageFile.readAsBytes();

    // Detect content type based on file extension
    final fileExtension = imageFile.path.toLowerCase().split('.').last;
    final contentType = fileExtension == 'png' ? 'image/png' : 'image/jpeg';
    final storageExtension = fileExtension == 'png' ? 'png' : 'jpg';

    // Upload to same path: network_cards/{userId}/{cardId}.{extension}
    // This will automatically overwrite the existing image
    final ref = _storage
        .ref()
        .child('network_cards')
        .child(user.uid)
        .child('$cardId.$storageExtension');

    final metadata = SettableMetadata(
      contentType: contentType,
      cacheControl: 'max-age=3600',
    );

    final snapshot = await ref.putData(imageBytes, metadata);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl.toString();
  }

  Future<String> uploadMyCardImage(File imageFile, String cardId) async {
    if (!await imageFile.exists()) {
      throw Exception('Image file does not exist');
    }

    final fileSize = await imageFile.length();
    if (fileSize == 0) {
      throw Exception('Image file is empty');
    }

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Read file bytes and use putData (avoids file access issues)
    final imageBytes = await imageFile.readAsBytes();

    // Detect content type based on file extension
    final fileExtension = imageFile.path.toLowerCase().split('.').last;
    final contentType = fileExtension == 'png' ? 'image/png' : 'image/jpeg';
    final storageExtension = fileExtension == 'png' ? 'png' : 'jpg';

    // Upload to: my_cards/{userId}/{cardId}.{extension}
    final ref = _storage
        .ref()
        .child('my_cards')
        .child(user.uid)
        .child('$cardId.$storageExtension');

    final metadata = SettableMetadata(
      contentType: contentType,
      cacheControl: 'max-age=3600',
    );

    final snapshot = await ref.putData(imageBytes, metadata);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl.toString();
  }

  Future<String> uploadImageToTextImage(
      File imageFile, String documentId) async {
    if (!await imageFile.exists()) {
      throw Exception('Image file does not exist');
    }

    final fileSize = await imageFile.length();
    if (fileSize == 0) {
      throw Exception('Image file is empty');
    }

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Read file bytes and use putData (avoids file access issues)
    final imageBytes = await imageFile.readAsBytes();

    // Detect content type based on file extension
    final fileExtension = imageFile.path.toLowerCase().split('.').last;
    final contentType = fileExtension == 'png' ? 'image/png' : 'image/jpeg';
    final storageExtension = fileExtension == 'png' ? 'png' : 'jpg';

    // Upload to: image_to_text/{userId}/{documentId}.{extension}
    final ref = _storage
        .ref()
        .child('image_to_text')
        .child(user.uid)
        .child('$documentId.$storageExtension');

    final metadata = SettableMetadata(
      contentType: contentType,
      cacheControl: 'max-age=3600',
    );

    final snapshot = await ref.putData(imageBytes, metadata);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl.toString();
  }

  Future<String> uploadCompanyLogo(File imageFile, String cardId) async {
    if (!await imageFile.exists()) {
      throw Exception('Image file does not exist');
    }

    final fileSize = await imageFile.length();
    if (fileSize == 0) {
      throw Exception('Image file is empty');
    }

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    // Read file bytes and use putData (avoids file access issues)
    final imageBytes = await imageFile.readAsBytes();

    // Detect content type based on file extension
    final fileExtension = imageFile.path.toLowerCase().split('.').last;
    final contentType = fileExtension == 'png' ? 'image/png' : 'image/jpeg';
    final storageExtension = fileExtension == 'png' ? 'png' : 'jpg';

    // Upload to: my_cards_logos/{userId}/{cardId}_logo.{extension}
    final ref = _storage
        .ref()
        .child('my_cards_logos')
        .child(user.uid)
        .child('${cardId}_logo.$storageExtension');

    final metadata = SettableMetadata(
      contentType: contentType,
      cacheControl: 'max-age=3600',
    );

    final snapshot = await ref.putData(imageBytes, metadata);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl.toString();
  }
}
