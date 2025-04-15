import 'dart:io';

class MaintenanceList {
  String description;
  bool periodic;
  int mileage;
  DateTime expectedDate;
  File? image; // Optional image field

  MaintenanceList({
    required this.description,
    required this.periodic,
    required this.mileage,
    required this.expectedDate,
    this.image,
  });

  factory MaintenanceList.fromJson(Map<String, dynamic> data) {
    return MaintenanceList(
      description: data['Description'] ?? '',
      periodic: data['Periodic'] ?? false,
      mileage: data['mileage'] ?? 0,
      expectedDate: (data['expectedDate'])?.toDate() ?? DateTime.now(),
    );
  }
  void addMaintenanceHistory(
      String description, bool periodic, int mileage, DateTime expectedDate) {
    ({
      "Description": description,
      "Periodic": false,
      "mileage": mileage,
      "expectedDate": expectedDate
    });
    // logic to add special cases to the history tab
  }
}
