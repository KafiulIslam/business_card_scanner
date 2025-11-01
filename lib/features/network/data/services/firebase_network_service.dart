import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_card.dart';

class FirebaseNetworkService {
  final FirebaseFirestore _firestore;

  FirebaseNetworkService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveNetworkCard(NetworkCard card) async {
    try {
      final data = card.toMap();
      // Ensure createdAt is set if not provided
      if (!data.containsKey('createdAt') || data['createdAt'] == null) {
        data['createdAt'] = FieldValue.serverTimestamp();
      }
      await _firestore.collection('network').doc(card.cardId).set(data);
    } catch (e) {
      throw Exception('Failed to save network card: $e');
    }
  }

  Future<List<NetworkCard>> getNetworkCardsByUid(String uid) async {
    try {
      QuerySnapshot snapshot;
      try {
        // Try with orderBy first
        snapshot = await _firestore
            .collection('network')
            .where('uid', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .get();
      } catch (e) {
        // If orderBy fails (index not created), fetch without orderBy
        snapshot = await _firestore
            .collection('network')
            .where('uid', isEqualTo: uid)
            .get();
      }

      final cards = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // createdAt will be handled in fromMap if not present
            return NetworkCard.fromMap(data);
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
      throw Exception('Failed to fetch network cards: $e');
    }
  }

  Stream<List<NetworkCard>> getNetworkCardsStreamByUid(String uid) {
    return _firestore
        .collection('network')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
              final data = doc.data();
              data['createdAt'] = doc.data()['createdAt'];
              return NetworkCard.fromMap(data);
            })
            .toList());
  }
}

