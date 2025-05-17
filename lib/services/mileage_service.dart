import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MileageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> getCarMileage(String carId) async {
    if (carId.isEmpty) {
      print('Empty car ID provided to getCarMileage');
      return 0;
    }
    
    try {
      // First attempt to get mileage
      final doc = await _firestore.collection('cars').doc(carId).get();
      
      // Handle mileage that could be either double or int
      var rawMileage = doc.data()?['mileage'];
      int mileage = 0;
      
      if (rawMileage != null) {
        // Convert to int regardless of whether it's double or int
        mileage = (rawMileage is double) ? rawMileage.toInt() : (rawMileage as int);
      }
      
      // If mileage is 0, try up to 2 more times with a short delay
      // This helps with race conditions when a car was just added
      if (mileage == 0) {
        print('Initial mileage reading is 0 for car $carId, will retry...');
        
        // Wait a moment for Firestore to complete any pending writes
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Second attempt
        final retryDoc = await _firestore.collection('cars').doc(carId).get();
        rawMileage = retryDoc.data()?['mileage'];
        
        if (rawMileage != null) {
          mileage = (rawMileage is double) ? rawMileage.toInt() : (rawMileage as int);
        }
        
        if (mileage == 0) {
          // Wait a bit longer and try one more time
          await Future.delayed(const Duration(milliseconds: 1000));
          
          // Third attempt
          final finalDoc = await _firestore.collection('cars').doc(carId).get();
          rawMileage = finalDoc.data()?['mileage'];
          
          if (rawMileage != null) {
            mileage = (rawMileage is double) ? rawMileage.toInt() : (rawMileage as int);
          }
          
          if (mileage == 0) {
            print('After retries, mileage is still 0 for car $carId');
          } else {
            print('Successfully retrieved mileage on retry: $mileage');
          }
        } else {
          print('Successfully retrieved mileage on first retry: $mileage');
        }
      }
      
      return mileage;
    } catch (e) {
      print('Error getting mileage: $e');
      return 0;
    }
  }

  Future<void> updateCarMileage(String carId, int newMileage) async {
    try {
      // Store mileage as int to ensure consistency
      await _firestore.collection('cars').doc(carId).update({
        'mileage': newMileage,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('✅ Successfully updated mileage for car $carId to $newMileage');
    } catch (e) {
      print('❌ Error updating mileage: $e');
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