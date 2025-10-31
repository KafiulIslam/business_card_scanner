import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business_card_scanner/features/network/domain/entities/network_card.dart';

class FirebaseNetworkService {
  final FirebaseFirestore _firestore;

  FirebaseNetworkService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveNetworkCard(NetworkCard card) async {
    try {
      await _firestore.collection('network').doc(card.cardId).set(card.toMap());
    } catch (e) {
      throw Exception('Failed to save network card: $e');
    }
  }

  Future<List<NetworkCard>> getNetworkCardsByUid(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('network')
          .where('uid', isEqualTo: uid)
          .get();

      return snapshot.docs
          .map((doc) => NetworkCard.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch network cards: $e');
    }
  }
}

