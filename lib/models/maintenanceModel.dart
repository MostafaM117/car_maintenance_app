
class MaintenanceList {
  final String id;
  final String description;
  final int mileage;
  final DateTime expectedDate;
  bool isDone; 

  MaintenanceList({
    required this.id,
    required this.description,
    required this.mileage,
    required this.expectedDate,
    required this.isDone
  });
  
  DateTime calculateExpectedDate(dynamic currentMileage, dynamic avgKmPerMonth) {
    final int currentMileageInt = _toInt(currentMileage);
    final int avgKmPerMonthInt = _toInt(avgKmPerMonth);
    if (avgKmPerMonthInt <= 10) {
      return expectedDate;
    }
    final int remainingKm = mileage - currentMileageInt;
    if (remainingKm <= 0) {
      return DateTime.now();
    }
    final double monthsUntilDue = remainingKm / avgKmPerMonthInt;
    final DateTime today = DateTime.now();
    return today.add(Duration(days: (monthsUntilDue * 30).round()));
  }
  
  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
  
  String formatExpectedDate(dynamic currentMileage, dynamic avgKmPerMonth) {
    final DateTime date = calculateExpectedDate(currentMileage, avgKmPerMonth);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  factory MaintenanceList.fromJson(Map<String, dynamic> data, String docId) {
    return MaintenanceList(
      id: docId,
      description: data['Description'] ?? '',
      mileage: data['mileage'] ?? 0,
      expectedDate: (data['expectedDate'])?.toDate() ?? DateTime.now(),
      isDone: data['isDone'],
    );
  }
}

//LOJY IS THE BEST
