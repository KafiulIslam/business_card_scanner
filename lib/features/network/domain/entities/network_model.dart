import 'package:cloud_firestore/cloud_firestore.dart';

class NetworkModel {
  final String? cardId;
  final String? uid;
  final String? imageUrl;
  final String? category;
  final String? note;
  final String? name;
  final String? title;
  final String? company;
  final String? companyLogo;
  final String? email;
  final String? phone;
  final String? address;
  final String? website;
  final DateTime? createdAt;
  final bool? isCameraScanned;
  final String? sourceType;

  NetworkModel({
    this.cardId,
    this.uid,
    this.imageUrl,
    this.category,
    this.note,
    this.name,
    this.title,
    this.company,
    this.companyLogo,
    this.email,
    this.phone,
    this.address,
    this.website,
    this.createdAt,
    this.isCameraScanned,
    this.sourceType,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (cardId != null) map['cardId'] = cardId;
    if (uid != null) map['uid'] = uid;
    if (imageUrl != null) map['imageUrl'] = imageUrl;
    if (category != null) map['category'] = category;
    if (note != null) map['note'] = note;
    if (name != null) map['name'] = name;
    if (title != null) map['title'] = title;
    if (company != null) map['company'] = company;
    if (companyLogo != null) map['company_logo'] = companyLogo;
    if (email != null) map['email'] = email;
    if (phone != null) map['phone'] = phone;
    if (address != null) map['address'] = address;
    if (website != null) map['website'] = website;
    if (createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    if (isCameraScanned != null) map['isCameraScanned'] = isCameraScanned;
    if (sourceType != null) map['sourceType'] = sourceType;
    return map;
  }

  factory NetworkModel.fromMap(Map<String, dynamic> map) {
    DateTime? createdAt;
    if (map['createdAt'] != null) {
      if (map['createdAt'] is DateTime) {
        createdAt = map['createdAt'] as DateTime;
      } else if (map['createdAt'] is Timestamp) {
        createdAt = (map['createdAt'] as Timestamp).toDate();
      }
    }

    return NetworkModel(
      cardId: map['cardId']?.toString(),
      uid: map['uid']?.toString(),
      imageUrl: map['imageUrl']?.toString(),
      category: map['category']?.toString(),
      note: map['note']?.toString(),
      name: map['name']?.toString(),
      title: map['title']?.toString(),
      company: map['company']?.toString(),
      companyLogo: map['company_logo']?.toString(),
      email: map['email']?.toString(),
      phone: map['phone']?.toString(),
      address: map['address']?.toString(),
      website: map['website']?.toString(),
      createdAt: createdAt,
      isCameraScanned: map['isCameraScanned'] as bool?,
      sourceType: map['sourceType']?.toString(),
    );
  }
}
