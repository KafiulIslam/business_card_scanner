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
  });

  Map<String, String> toMap() {
    return {
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
  }

  factory NetworkCard.fromMap(Map<String, dynamic> map) {
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
    );
  }
}

