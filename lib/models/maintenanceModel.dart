class MaintenanceList {
  String description;
  bool periodic;
  int mileage;
  DateTime expectedDate;

  MaintenanceList({
    required this.description,
    required this.periodic,
    required this.mileage,
    required this.expectedDate,
  });

  factory MaintenanceList.fromJson(Map<String, dynamic> data) {
    return MaintenanceList(
      description: data['Description'] ?? '',
      periodic: data['Periodic'] ?? false,
      mileage: data['mileage'] ?? 0,
      expectedDate: (data['expectedDate'])?.toDate() ?? DateTime.now(),
    );
  }
}
