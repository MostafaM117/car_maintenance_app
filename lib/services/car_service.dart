import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/screens/Current_Screen/main_screen.dart';

/// Service responsible for car data submission and form handling
class CarService {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final TextEditingController mileageController;
  final TextEditingController avgKmPerMonthController;
  final String? selectedMake;
  final String? selectedModel;
  final int? selectedYear;
  final DateTime? lastMaintenanceDate;
  
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  CarService({
    required this.context,
    required this.formKey,
    required this.mileageController,
    required this.avgKmPerMonthController,
    required this.selectedMake,
    required this.selectedModel,
    required this.selectedYear,
    required this.lastMaintenanceDate,
  });

  Future<void> submitForm(Function(bool) setLoading) async {
    if (formKey.currentState!.validate()) {
      if (lastMaintenanceDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select last maintenance date')),
        );
        return;
      }

      setLoading(true);

      try {
        await saveCar();
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding car: ${e.toString()}')),
        );
      } finally {
        setLoading(false);
      }
    }
  }

  Future<void> saveCar() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    if (!userDoc.exists) {
      throw Exception('User document not found');
    }

    final username = userDoc.data()?['username'] as String?;
    if (username == null) {
      throw Exception('Username not found');
    }

    final carId = _firestore.collection('cars').doc().id;

    final lastMaintenanceDateTime = DateTime(
      (lastMaintenanceDate ?? DateTime.now()).year,
      (lastMaintenanceDate ?? DateTime.now()).month,
      (lastMaintenanceDate ?? DateTime.now()).day,
    );

    await _firestore.collection('cars').doc(carId).set({
      'carId': carId,
      'make': selectedMake,
      'model': selectedModel,
      'year': selectedYear,
      'mileage': double.parse(mileageController.text.trim()),
      'avgKmPerMonth': double.parse(avgKmPerMonthController.text.trim()),
      'lastMaintenance': Timestamp.fromDate(lastMaintenanceDateTime),
      'userId': user.uid,
      'username': username,
    });

    await _firestore.collection('users').doc(user.uid).update({
      'carAdded': true,
    });
  }

  /// Get a stream of the current user's cars
  static Stream<QuerySnapshot> getUserCarsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    
    return _firestore
        .collection('cars')
        .where('userId', isEqualTo: user.uid)
        .snapshots();
  }

  /// Get the current user's cars as a Future
  static Future<List<Map<String, dynamic>>> getUserCars() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    
    final snapshot = await _firestore
        .collection('cars')
        .where('userId', isEqualTo: user.uid)
        .get();
    
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }
  static Future<void> deleteCar(String carId) async {
    try {
      await _firestore.collection('cars').doc(carId).delete();
    } catch (e) {
      print('Error deleting car: $e');
      throw e;
    }
  }
}