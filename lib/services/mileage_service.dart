import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MileageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> getCarMileage(String carId) async {
    try {
      final doc = await _firestore.collection('cars').doc(carId).get();
      return doc.data()?['mileage'] ?? 0;
    } catch (e) {
      print('Error getting mileage: $e');
      return 0;
    }
  }

  Future<void> updateCarMileage(String carId, int newMileage) async {
    try {
      await _firestore.collection('cars').doc(carId).update({
        'mileage': newMileage,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating mileage: $e');
      throw e;
    }
  }

  Future<int> autoUpdateMileage(String carId) async {
    try {

      final carDoc = await _firestore.collection('cars').doc(carId).get();
      if (!carDoc.exists) {
        throw Exception('Car not found');
      }

      final carData = carDoc.data()!;
      final currentMileage = carData['mileage'] as num;
      final avgKmPerMonth = carData['avgKmPerMonth'] as num;
      
      final lastUpdated = carData['lastUpdated'] as Timestamp?;
      
      if (lastUpdated == null) {
        await _firestore.collection('cars').doc(carId).update({
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        return currentMileage.toInt();
      }
      
      final now = DateTime.now();
      final lastUpdateDate = lastUpdated.toDate();
      
      final monthsDifference = (now.year - lastUpdateDate.year) * 12 + 
                              (now.month - lastUpdateDate.month) +
                              (now.day - lastUpdateDate.day) / 30.0;
      
      // Only update if at least one day has passed
      if (monthsDifference < 0.03) { // ~1 day threshold
        return currentMileage.toInt();
      }
      
      final additionalKm = (avgKmPerMonth * monthsDifference).round();
      final newMileage = currentMileage.toInt() + additionalKm;
      
      await _firestore.collection('cars').doc(carId).update({
        'mileage': newMileage,
        'lastUpdated': FieldValue.serverTimestamp(), //thats why it resets to current time after updating
      });
      
      print('Auto-updated mileage from $currentMileage to $newMileage based on $monthsDifference months elapsed');
      
      return newMileage;
    } catch (e) {
      print('Error auto-updating mileage: $e');
      throw e;
    }
  }
}