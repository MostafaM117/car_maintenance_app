import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  final String id;
  final String title;
  final String description;
  final double originalPrice;
  final double discountPercentage;
  final double priceAfterDiscount;
  final DateTime validUntil;
  final String business_name;
  final String imageUrl;
  final String phoneNumber;
  final double longitude;
  final double latitude;
  Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountPercentage,
    required this.priceAfterDiscount,
    required this.validUntil,
    required this.business_name,
    this.imageUrl = '',
    required this.phoneNumber,
    required this.longitude,
    required this.latitude,
  });

  Offer copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    DateTime? validUntil,
    String? business_name,
    String? imageUrl,
    String? phoneNumber,
    double? longitude,
    double? latitude,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      priceAfterDiscount: priceAfterDiscount,
      validUntil: validUntil ?? this.validUntil,
      business_name: business_name ?? this.business_name,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
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
      'business_name': business_name,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
      'longitude': longitude,
      'latitude': latitude,
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
      business_name: data['business_name'] ?? 'Unknown Business',
      imageUrl: data['imageUrl'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      longitude: data['longitude'] ?? '',
      latitude: data['latitude'] ?? '',
    );
  }
}
