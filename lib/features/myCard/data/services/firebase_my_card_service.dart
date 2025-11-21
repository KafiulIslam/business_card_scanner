import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_card_scanner/features/myCard/domain/entities/my_card_model.dart';

class FirebaseMyCardService {
  final FirebaseFirestore _firestore;

  FirebaseMyCardService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveMyCard(MyCardModel card) async {
    try {
      if (card.cardId == null) {
        throw Exception('Card ID is required to save my card');
      }
      final data = card.toMap();
      // Ensure createdAt is always set to current date time (DateTime.now())
      // If createdAt is not provided in the card, use current time
      if (card.createdAt == null) {
        data['createdAt'] = Timestamp.fromDate(DateTime.now());
      } else {
        data['createdAt'] = Timestamp.fromDate(card.createdAt!);
      }
      await _firestore.collection('my_card').doc(card.cardId!).set(data);
    } catch (e) {
      throw Exception('Failed to save my card: $e');
    }
  }

  Future<List<MyCardModel>> getMyCardsByUid(String uid) async {
    try {
      QuerySnapshot snapshot;
      try {
        // Try with orderBy first
        snapshot = await _firestore
            .collection('my_card')
            .where('uid', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .get();
      } catch (e) {
        // If orderBy fails (index not created), fetch without orderBy
        snapshot = await _firestore
            .collection('my_card')
            .where('uid', isEqualTo: uid)
            .get();
      }

      final cards = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // createdAt will be handled in fromMap if not present
            return MyCardModel.fromMap(data);
          })
          .toList();

      // Sort manually if orderBy wasn't used
      cards.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      return cards;
    } catch (e) {
      throw Exception('Failed to fetch my cards: $e');
    }
  }

  Stream<List<MyCardModel>> getMyCardsStreamByUid(String uid) {
    return _firestore
        .collection('my_card')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data();
              data['createdAt'] = doc.data()['createdAt'];
              return MyCardModel.fromMap(data);
            })
            .toList());
  }

  Future<void> updateMyCard(String documentId, MyCardModel card) async {
    try {
      if (documentId.isEmpty) {
        throw Exception('Document ID is required to update my card');
      }
      if (card.cardId == null) {
        throw Exception('Card ID is required to update my card');
      }
      
      // Get only the fields that should be updated (exclude createdAt and cardId)
      final data = card.toMap();
      // Remove fields that shouldn't be updated
      data.remove('createdAt');
      data.remove('cardId');
      data.remove('uid'); // UID should not be changed
      
      // Only update non-null fields
      final updateData = <String, dynamic>{};
      data.forEach((key, value) {
        if (value != null) {
          updateData[key] = value;
        }
      });
      
      if (updateData.isEmpty) {
        throw Exception('No fields to update');
      }
      
      await _firestore.collection('my_card').doc(documentId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update my card: $e');
    }
  }

  Future<void> deleteMyCard(String cardId) async {
    try {
      if (cardId.isEmpty) {
        throw Exception('Card ID is required to delete my card');
      }
      await _firestore.collection('my_card').doc(cardId).delete();
    } catch (e) {
      throw Exception('Failed to delete my card: $e');
    }
  }

}

