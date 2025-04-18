import 'dart:io';

class MaintenanceList {
  final String id;
  final String description;
  final bool periodic;
  final int mileage;
  File? image; // Optional image field
  final DateTime expectedDate;

  MaintenanceList({
    required this.id,
    required this.description,
    required this.periodic,
    required this.mileage,
    this.image,
    required this.expectedDate,
  });

  factory MaintenanceList.fromJson(Map<String, dynamic> data, String docId) {
    return MaintenanceList(
      id: docId, // Set the id from the docId parameter
      description: data['Description'] ?? '',
      periodic: data['Periodic'] ?? false,
      mileage: data['mileage'] ?? 0,
    );
  }
}
