class MaintenanceList {
  final String id; // Add the id field for the Firestore document ID
  final String description;
  final bool periodic;
  final int mileage;
  final DateTime expectedDate;

  MaintenanceList({
    required this.id, // Include id in the constructor
    required this.description,
    required this.periodic,
    required this.mileage,
    required this.expectedDate,
  });

  factory MaintenanceList.fromJson(Map<String, dynamic> data, String docId) {
    return MaintenanceList(
      id: docId, // Set the id from the docId parameter
      description: data['Description'] ?? '',
      periodic: data['Periodic'] ?? false,
      mileage: data['mileage'] ?? 0,
      expectedDate: (data['expectedDate'])?.toDate() ?? DateTime.now(),
    );
  }
}
