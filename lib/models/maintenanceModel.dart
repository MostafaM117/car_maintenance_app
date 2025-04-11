class MaintenanceList {
  String description;
  bool periodic;
  int mileage;

  MaintenanceList({
    required this.description,
    required this.periodic,
    required this.mileage,
  });

  factory MaintenanceList.fromJson(Map<String, dynamic> data) {
    return MaintenanceList(
      description: data['Description'] ?? '',
      periodic: data['Periodic'] ?? false,
      mileage: data['mileage'] ?? 0,
    );
  }
}
