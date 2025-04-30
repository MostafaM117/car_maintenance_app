// import 'package:car_maintenance/models/MaintID.dart';
// // import 'package:car_maintenance/notifications/notification.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:car_maintenance/Back-end/firestore_service.dart';
// import 'package:car_maintenance/models/maintenanceModel.dart';

// class MaintenanceScreen extends StatefulWidget {
//   const MaintenanceScreen({super.key});

//   @override
//   State<MaintenanceScreen> createState() => _MaintenanceScreenState();
// }

// class _MaintenanceScreenState extends State<MaintenanceScreen> {
//   late FirestoreService firestoreService;

//   @override
//   void initState() {
//     super.initState();
//     firestoreService = FirestoreService(MaintID());
//     // Listen for changes in MaintID and update the FirestoreService accordingly
//     MaintID().addListener(_updateService);
//   }

//   void _updateService() {
//     setState(() {
//       firestoreService = FirestoreService(MaintID());
//     });
//   }

//   @override
//   void dispose() {
//     MaintID().removeListener(_updateService);
//     super.dispose();
//   }

// // make it into a gesture detector to remove the widget from view and copy the item to history (on swipe?)
//   //  Checkbox(
//   //   value: itemCheckedStates[maintenanceItem.id],
//   //   onChanged: (bool? isDone) async {
//   //     setState(() {
//   //       itemCheckedStates[maintenanceItem.id] =
//   //           isDone!;
//   //     });

//   //     if (isDone != null && isDone) {
//   //       // Copy the item to the history
//   //       await firestoreService
//   //           .moveToHistory(maintenanceItem.id);
//   //       print("✅ Moved to history");
//   //     }
//   //   },
//   // ),

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Maintenance History'),
//       ),
//       body: StreamBuilder<List<MaintenanceList>>(
//         stream: firestoreService.getMaintenanceHistory(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: CircularProgressIndicator());
//           }
//           final historyList = snapshot.data!;
//           if (historyList.isEmpty) {
//             return Center(child: Text("No maintenance history available."));
//           }

//           return ListView.builder(
//             itemCount: historyList.length,
//             itemBuilder: (context, index) {
//               final maintenanceItem = historyList[index];

//               return Dismissible(
//                 key: Key(maintenanceItem.id),
//                 direction: DismissDirection.endToStart,
//                 child: Card(
//                   child: ListTile(
//                     title: Text(maintenanceItem.mileage.toString()),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(maintenanceItem.expectedDate.toString()),
//                         SizedBox(height: 4),
//                         // Text(maintenanceItem.description),
//                       ],
//                     ),
//                   ),
//                 ),
//                 onDismissed: (direction) async {
//                   await firestoreService.recoverFromHistory(
//                       maintenanceItem.id); // This updates `isDone` in Firestore

//                   // setState(() {
//                   //   itemCheckedStates[maintenanceItem.id] =
//                   //       true; // This updates the local UI state
//                   // });
//                   print("✅ Moved to history");
//                 },
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           firestoreService.cloneMaintenanceToUser(
//             source: FirebaseFirestore.instance
//                 .collection('Maintenance_Schedule_MG ZS 2019'),
//             target: FirebaseFirestore.instance
//                 .collection('Maintenance_Schedule_MG ZS 2020'),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/models/MaintID.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';

import '../widgets/maintenance_card.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  late FirestoreService firestoreService;
  final MaintID maintID = MaintID(); 

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(maintID);
    maintID.addListener(_updateService);
  }

  void _updateService() {
    setState(() {
      firestoreService = FirestoreService(maintID);
    });
  }

  @override
  void dispose() {
    maintID.removeListener(_updateService);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                const Text(
                  'Maintenance',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                // const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<List<MaintenanceList>>(
                    stream: firestoreService.getMaintenanceHistory(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final historyList = snapshot.data!;
                      if (historyList.isEmpty) {
                        return const Center(
                            child: Text("No maintenance history available."));
                      }

                      return ListView.builder(
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          final maintenanceItem = historyList[index];

                          return Dismissible(
                            key: Key(maintenanceItem.id),
                            direction: DismissDirection.endToStart,
                            child: MaintenanceCard(
                              title: '${maintenanceItem.mileage} KM',
                              date: maintenanceItem.expectedDate
                                  .toString()
                                  .split(' ')[0],
                            ),
                            onDismissed: (direction) async {
                              await firestoreService.recoverFromHistory(
                                  maintenanceItem.id);
                              print("✅ Moved to history");
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          firestoreService.cloneMaintenanceToUser(
            source: FirebaseFirestore.instance
                .collection('Maintenance_Schedule_MG ZS 2019'),
            target: FirebaseFirestore.instance
                .collection('Maintenance_Schedule_MG ZS 2020'),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}