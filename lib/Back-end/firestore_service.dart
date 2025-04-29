import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference maintCollection;
  final user = FirebaseAuth.instance.currentUser;
  late final CollectionReference historyCollection;
  late final CollectionReference personalMaintCollection;

  FirestoreService(MaintID maintID)
      : maintCollection = FirebaseFirestore.instance
            .collection('Maintenance_Schedule_${MaintID().maintID}') {
    personalMaintCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Maintenance_Schedule_${MaintID().maintID}_Personal');
    historyCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("maintHistory ${MaintID().maintID}");
  }
  //add special cases
  Future<void> addSpecialMaintenance(String description, bool isDone,
      int mileage, DateTime expectedDate) async {
    await historyCollection.add({
      "Description": description,
      "isDone": true,
      "mileage": mileage,
      "expectedDate": expectedDate
    });
  }

  Future<void> cloneMaintenanceToUser({
    required CollectionReference source,
    required CollectionReference target,
  }) async {
    final sourceSnapshot = await source.get();
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in sourceSnapshot.docs) {
      final targetDoc = target.doc(doc.id);
      batch.set(targetDoc, doc.data());
    }

    await batch.commit();
  }

  //get lists
  Stream<List<MaintenanceList>> getMaintenanceList() {
    return personalMaintCollection.snapshots().map((snapshot) {
      //debug print
      print("📡 Firestore returned ${snapshot.docs.length} documents");

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        //debug print
        // print("📜 Mapping Firestore document: $data");
        return MaintenanceList(
          id: doc.id,
          description: data['Description'] ?? '',
          mileage: (data['mileage'] ?? 0) as int,
          expectedDate: (data['expectedDate'])?.toDate() ??
              DateTime.now().add(Duration(days: 30)),
          isDone: (data['isDone'] ?? false) as bool,
        );
      }).toList();
    });
  }

  // Method to copy a maintenance item to the history collection
  Future<void> moveToHistory(String docId) async {
    try {
      final docSnapshot = await personalMaintCollection.doc(docId).get();
      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        await personalMaintCollection.doc(docId).update({'isDone': true});

        await historyCollection.add(data); // Copy the item to history

        await personalMaintCollection
            .doc(docId)
            .delete(); // Delete from personal collection
        print("✅ Moved maintenance item to history");
      } else {
        print("❌ No data found for docId: $docId");
      }
    } catch (e) {
      print("❌ Error moving maintenance to history: $e");
    }
  }

  // Future<void> deleteMaintenance(String docId) async {
  // try {
  //  await personalMaintCollection.doc(docId).delete();
  // print("✅ Deleted maintenance item with ID: $docId");
  // } catch (e) {
  // print("❌ Error deleting maintenance item: $e");
  // }
  //}

  Stream<List<MaintenanceList>> getMaintenanceHistory() {
    return historyCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return MaintenanceList.fromJson(data, doc.id);
      }).toList();
    });
  }

  Future<void> recoverFromHistory(String docId) async {
    try {
      final docSnapshot = await historyCollection.doc(docId).get();
      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        await historyCollection.doc(docId).update({'isDone': false});

        await personalMaintCollection.add(data); // Copy the item to history

        await historyCollection.doc(docId).delete();

        print("✅ Recovered maintenance item from history");
      } else {
        print("❌ No data found for docId: $docId");
      }
    } catch (e) {
      print("❌ Error recovering maintenance from history: $e");
    }
  }
}
