
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
  final int stockCount;
  final double price;
  final String businessName;
  ProductItem({
    required this.id,
    required this.name,
    required this.description,
    required this.selectedMake,
    required this.selectedModel,
    required this.imageUrl,
    required this.selectedCategory,
    required this.selectedAvailability,
    required this.stockCount,
    required this.price,
    required this.businessName,
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
      stockCount: data['stockCount'] ?? 0,
      price: data['price']?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'], // Optional image URL
      businessName: data['Store Name'] ?? '',
    );
  }
}

//LOJY IS THE BEST
