import 'package:cloud_firestore/cloud_firestore.dart';

class NetworkCard {
  final String cardId;
  final String uid;
  final String imageUrl;
  final String category;
  final String note;
  final String name;
  final String title;
  final String company;
  final String email;
  final String phone;
  final String address;
  final String website;
  final DateTime? createdAt;

  NetworkCard({
    required this.cardId,
    required this.uid,
    required this.imageUrl,
    required this.category,
    required this.note,
    required this.name,
    required this.title,
    required this.company,
    required this.email,
    required this.phone,
    required this.address,
    required this.website,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'cardId': cardId,
      'uid': uid,
      'imageUrl': imageUrl,
      'category': category,
      'note': note,
      'name': name,
      'title': title,
      'company': company,
      'email': email,
      'phone': phone,
      'address': address,
      'website': website,
    };
    // createdAt will be handled by FirebaseNetworkService to always use DateTime.now()
    if (createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }

  factory NetworkCard.fromMap(Map<String, dynamic> map) {
    DateTime? createdAt;
    if (map['createdAt'] != null) {
      if (map['createdAt'] is DateTime) {
        createdAt = map['createdAt'] as DateTime;
      } else if (map['createdAt'] is Timestamp) {
        createdAt = (map['createdAt'] as Timestamp).toDate();
      }
    }
    
    return NetworkCard(
      cardId: map['cardId']?.toString() ?? '',
      uid: map['uid']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      note: map['note']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      company: map['company']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      website: map['website']?.toString() ?? '',
      createdAt: createdAt,
    );
  }
}

