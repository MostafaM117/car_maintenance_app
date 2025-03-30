import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';
import 'package:car_maintenance/models/MaintID.dart';
// import 'package:car_maintenance/forms/carform.dart';
// import 'package:car_maintenance/screens/formscreens/formscreen1.dart';

class FirestoreService {
  final CollectionReference maintCollection;

  FirestoreService(MaintID maintID)
      : maintCollection = FirebaseFirestore.instance.collection(
            'Maintenance_Schedule_${MaintID().maintID}'); //attempt 1
  // final CollectionReference maintCollection = FirebaseFirestore.instance
  //     .collection('Maintenance_Schedule_Nissan_Sunny');

  //add special cases
  Future<void> addMaintenanceList(String description) async {
    await maintCollection
        .add({"Description": description, "Periodic": false, "mileage": 0});
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
          description: data['Description'] ?? '',
          mileage: (data['mileage'] ?? 0) as int,
          periodic: (data['Periodic'] ?? false) as bool,
        );
      }).toList();
    });
  }
}
