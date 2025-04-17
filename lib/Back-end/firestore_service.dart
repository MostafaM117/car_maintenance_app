import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference maintCollection;
  final user = FirebaseAuth.instance.currentUser;
  late final CollectionReference historyCollection;

  FirestoreService(MaintID maintID)
      : maintCollection = FirebaseFirestore.instance
            .collection('Maintenance_Schedule_${MaintID().maintID}') {
    historyCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("maintHistory");
  }
  //add special cases
  Future<void> addSpecialMaintenance(String description, bool periodic,
      int mileage, DateTime expectedDate) async {
    await historyCollection.add({
      "Description": description,
      "Periodic": false,
      "mileage": mileage,
      "expectedDate": expectedDate
    });

  }

  //get lists
  Stream<List<MaintenanceList>> getMaintenanceList() {
    return maintCollection.snapshots().map((snapshot) {
      //debug print
      print("📡 Firestore returned ${snapshot.docs.length} documents");

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        //debug print
        print("📜 Mapping Firestore document: $data");
        return MaintenanceList(
          id: doc.id,
          description: data['Description'] ?? '',
          mileage: (data['mileage'] ?? 0) as int,
          periodic: (data['Periodic'] ?? false) as bool,
        );
      }).toList();
    });
  }

  // Method to copy a maintenance item to the history collection
  Future<void> moveToHistory(String docId) async {
    try {
      final docSnapshot = await maintCollection.doc(docId).get();
      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        final historyRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('maintHistory');

        await historyRef.add(data); // Copy the item to history
        print("✅ Moved maintenance item to history");
      } else {
        print("❌ No data found for docId: $docId");
      }
    } catch (e) {
      print("❌ Error moving maintenance to history: $e");
    }
  }

  Stream<List<MaintenanceList>> getMaintenanceHistory() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('maintHistory')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return MaintenanceList.fromJson(data, doc.id);
      }).toList();
    });
  }
}
