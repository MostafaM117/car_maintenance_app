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
} 