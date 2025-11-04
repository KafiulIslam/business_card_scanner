import 'package:cloud_firestore/cloud_firestore.dart';

class MyCardModel {
  final String? cardId;
  final String? uid;
  final String? imageUrl;
  final String? category;
  final String? name;
  final String? title;
  final String? company;
  final String? email;
  final String? phone;
  final String? address;
  final String? website;
  final DateTime? createdAt;
  final bool? isCameraScanned;

  MyCardModel({
    this.cardId,
    this.uid,
    this.imageUrl,
    this.category,
    this.name,
    this.title,
    this.company,
    this.email,
    this.phone,
    this.address,
    this.website,
    this.createdAt,
    this.isCameraScanned,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (cardId != null) map['cardId'] = cardId;
    if (uid != null) map['uid'] = uid;
    if (imageUrl != null) map['imageUrl'] = imageUrl;
    if (category != null) map['category'] = category;
    if (name != null) map['name'] = name;
    if (title != null) map['title'] = title;
    if (company != null) map['company'] = company;
    if (email != null) map['email'] = email;
    if (phone != null) map['phone'] = phone;
    if (address != null) map['address'] = address;
    if (website != null) map['website'] = website;
    if (createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    if (isCameraScanned != null) map['isCameraScanned'] = isCameraScanned;
    return map;
  }

  factory MyCardModel.fromMap(Map<String, dynamic> map) {
    DateTime? createdAt;
    if (map['createdAt'] != null) {
      if (map['createdAt'] is DateTime) {
        createdAt = map['createdAt'] as DateTime;
      } else if (map['createdAt'] is Timestamp) {
        createdAt = (map['createdAt'] as Timestamp).toDate();
      }
    }

    return MyCardModel(
      cardId: map['cardId']?.toString(),
      uid: map['uid']?.toString(),
      imageUrl: map['imageUrl']?.toString(),
      category: map['category']?.toString(),
      name: map['name']?.toString(),
      title: map['title']?.toString(),
      company: map['company']?.toString(),
      email: map['email']?.toString(),
      phone: map['phone']?.toString(),
      address: map['address']?.toString(),
      website: map['website']?.toString(),
      createdAt: createdAt,
      isCameraScanned: map['isCameraScanned'] as bool?,
    );
  }
}

