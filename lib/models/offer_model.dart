import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final String id;
  final String title;
  final String description;
  final double originalPrice;
  final double discountPercentage;
  final double priceAfterDiscount;

  final DateTime validUntil;

  final String businessname;

  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountPercentage,
    required this.priceAfterDiscount,
    required this.validUntil,
    required this.businessname,
  });

  Offer copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    DateTime? validUntil,
    String? businessname,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      priceAfterDiscount: priceAfterDiscount,
      validUntil: validUntil ?? this.validUntil,
      businessname: businessname ?? this.businessname,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'priceAfterDiscount': priceAfterDiscount,
      'validUntil': validUntil,
      'businessname': businessname,
    };
  }

  factory Offer.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Offer(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      originalPrice: (data['originalPrice'] as num).toDouble(),
      discountPercentage: (data['discountPercentage'] as num).toDouble(),
      priceAfterDiscount: (data['priceAfterDiscount'] as num).toDouble(),
      validUntil: (data['validUntil'] as Timestamp).toDate(),
      businessname: data['businessname'] ?? 'Unknown Business',
    );
  }
}
