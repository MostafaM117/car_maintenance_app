import 'dart:io';

class ProductItem {
  // stock count and price need to be  also stored from add_item
  final String id;
  final String name;
  final String description;
  final String selectedMake;
  final String selectedModel;
  final String imageUrl; // Optional image URL
  final String selectedCategory;
  final String selectedAvailability;
  final double price;
  final String businessName;
  final String phoneNumber;
  final double longitude;
  final double latitude;
  ProductItem({
    required this.id,
    required this.name,
    required this.description,
    required this.selectedMake,
    required this.selectedModel,
    required this.imageUrl,
    required this.selectedCategory,
    required this.selectedAvailability,
    required this.price,
    required this.businessName,
    required this.phoneNumber,
    required this.longitude,
    required this.latitude,
  });

  factory ProductItem.fromJson(Map<String, dynamic> data, String docId) {
    return ProductItem(
      id: docId, // Set the id from the docId parameter
      description: data['Description'] ?? '',
      selectedMake: data['selectedMake'] ?? '',
      selectedModel: data['selectedModel'] ?? '',
      name: data['name'] ?? '',
      selectedCategory: data['selectedCategory'] ?? '',
      selectedAvailability: data['selectedAvailability'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'], // Optional image URL
      businessName: data['Store Name'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      longitude: data['longitude'] ?? '',
      latitude: data['latitude'] ?? '',
    );
  }
}

//LOJY IS THE BEST
