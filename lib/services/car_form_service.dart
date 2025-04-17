import 'package:cloud_firestore/cloud_firestore.dart';

class CarFormService {
  static Future<void> addCar({
    required String carId,
    required String selectedMake,
    required String selectedModel,
    required int selectedYear,
    required double mileage,
    required double avgKmPerMonth,
    required DateTime lastMaintenanceDateTime,
    required String userId,
    required String username,
  }) async {
    await FirebaseFirestore.instance.collection('cars').doc(carId).set({
      'carId': carId,
      'make': selectedMake,
      'model': selectedModel,
      'year': selectedYear,
      'mileage': mileage,
      'avgKmPerMonth': avgKmPerMonth,
      'lastMaintenance': Timestamp.fromDate(lastMaintenanceDateTime),
      'userId': userId,
      'username': username,
    });

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'carAdded': true,
    });
  }

  static String generateCarId(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${userId}_${timestamp}';
  }
}
