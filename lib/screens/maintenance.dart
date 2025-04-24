import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/notifications/notification.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  late FirestoreService firestoreService;
  Map<String, bool> itemCheckedStates = {}; // To store checked state per item
  bool isChecked = false; // Track the checked state of the checkbox
  @override
  void initState() {
    super.initState();

    firestoreService = FirestoreService(MaintID());
    // Listen for changes in MaintID and update the FirestoreService accordingly
    MaintID().addListener(_updateService);
  }

  void _updateService() {
    setState(() {
      firestoreService = FirestoreService(MaintID());
    });
  }

  @override
  void dispose() {
    MaintID().removeListener(_updateService);
    super.dispose();
  }

// make it into a gesture detector to remove the widget from view and copy the item to history (on swipe?)
  //  Checkbox(
  //   value: itemCheckedStates[maintenanceItem.id],
  //   onChanged: (bool? isDone) async {
  //     setState(() {
  //       itemCheckedStates[maintenanceItem.id] =
  //           isDone!;
  //     });

  //     if (isDone != null && isDone) {
  //       // Copy the item to the history
  //       await firestoreService
  //           .moveToHistory(maintenanceItem.id);
  //       print("✅ Moved to history");
  //     }
  //   },
  // ),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Maintenance History'),
      ),
      body: StreamBuilder<List<MaintenanceList>>(
        stream: firestoreService.getMaintenanceHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          final historyList = snapshot.data!;
          if (historyList.isEmpty) {
            return Center(child: Text("No maintenance history available."));
          }

          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final maintenanceItem = historyList[index];

              return Dismissible(
                key: Key(maintenanceItem.id),
                direction: DismissDirection.endToStart,
                child: Card(
                  child: ListTile(
                    title: Text(maintenanceItem.mileage.toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(maintenanceItem.expectedDate.toString()),
                        SizedBox(height: 4),
                        Text(maintenanceItem.description),
                      ],
                    ),
                  ),
                ),
                onDismissed: (direction) async {
                  await firestoreService.recoverFromHistory(
                      maintenanceItem.id); // This updates `isDone` in Firestore

                  setState(() {
                    itemCheckedStates[maintenanceItem.id] =
                        true; // This updates the local UI state
                  });

                  print("✅ Moved to history");
                },
              );
            },
          );
        },
      ),
    );
  }
}
