export '../services/car_service.dart';
export '../services/car_image_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/screens/Current_Screen/main_screen.dart';
import 'package:car_maintenance/models/MaintID.dart';

class CarService {
  final BuildContext context;
  final GlobalKey<FormState> formKey;
  final TextEditingController mileageController;
  final TextEditingController avgKmPerMonthController;
  final String? selectedMake;
  final String? selectedModel;
  final int? selectedYear;
  final DateTime? lastMaintenanceDate;


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
          SnackBar(content: Text('Please select last maintenance date')),
        );
        return;
      }

      setLoading(true);

      try {
        await saveCar();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false);
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final userDoc = await FirebaseFirestore.instance
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

    final carId = FirebaseFirestore.instance.collection('cars').doc().id;

    final lastMaintenanceDateTime = DateTime(
      (lastMaintenanceDate ?? DateTime.now()).year,
      (lastMaintenanceDate ?? DateTime.now()).month,
      (lastMaintenanceDate ?? DateTime.now()).day,
    );

    await FirebaseFirestore.instance.collection('cars').doc(carId).set({
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

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'carAdded': true,
    });
    // Save selected values globally
    MaintID().selectedMake = selectedMake.toString();
    MaintID().selectedModel = selectedModel.toString();
    MaintID().selectedYear = selectedYear.toString();
  }
}
