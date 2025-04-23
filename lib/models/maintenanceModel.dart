import 'dart:io';

class MaintenanceList {
  final String id;
  final String description;
  final bool periodic;
  final int mileage;
  File? image; // Optional image field
  final DateTime expectedDate;
  bool isDone; // Default value for isDone

  MaintenanceList(
      {required this.id,
      required this.description,
      required this.periodic,
      required this.mileage,
      this.image,
      required this.expectedDate,
      required this.isDone // Default value for isDone
      });

  factory MaintenanceList.fromJson(Map<String, dynamic> data, String docId) {
    return MaintenanceList(
      id: docId, // Set the id from the docId parameter
      description: data['Description'] ?? '',
      periodic: data['Periodic'] ?? false,
      mileage: data['mileage'] ?? 0,
      expectedDate: (data['expectedDate'])?.toDate() ?? DateTime.now(),
      isDone: data['isDone'],
    );
  }
}

//LOJY IS THE BEST
