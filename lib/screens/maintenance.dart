import 'package:car_maintenance/models/MaintID.dart';
import 'package:car_maintenance/notifications/notification.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/Back-end/firestore_service.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';

import 'addMaintenance.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  late FirestoreService firestoreService;

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(MaintID());
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

  void _showAddMaintenanceDialog(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController mileageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Maintenance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: mileageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Mileage'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final mileage = int.tryParse(mileageController.text);
                final description = descriptionController.text.trim();
                final expectedDate = DateTime
                    .now(); //will be changed after implementing the tracker

                if (description.isNotEmpty) {
                  firestoreService.addMaintenanceList(
                    description,
                    false,
                    mileage!,
                    expectedDate,
                  );
                  NotiService().showNotification(
                    title: 'Maintenance Added!',
                    body: description,
                  );
                }

                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Maintenance Schedule'),
          bottom: TabBar(tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Add New'),
          ]),
        ),
        body: TabBarView(children: <Widget>[
          // ✅ هنا شيلنا Expanded
          StreamBuilder<List<MaintenanceList>>(
            stream: firestoreService.getMaintenanceList(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              final maintList = snapshot.data!;
              if (maintList.isEmpty) {
                return Center(child: Text("No maintenance records available."));
              }
              return ListView.builder(
                itemCount: maintList.length,
                itemBuilder: (context, index) {
                  final maintenanceItem = maintList[index];
                  return Card(
                    child: ListTile(
                      title: Text(maintenanceItem.mileage.toString()),
                      subtitle: Text(maintenanceItem.description),
                    ),
                  );
                },
              );
            },
          ),
          Column(
            children: [

              Expanded(
                child: StreamBuilder<List<MaintenanceList>>(
                  stream: firestoreService.getMaintenanceList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final maintList = snapshot.data!;
                    if (maintList.isEmpty) {
                      return Center(
                          child: Text("No maintenance records available."));
                    }
                    return ListView.builder(
                      itemCount: maintList.length,
                      itemBuilder: (context, index) {
                        final maintenanceItem = maintList[index];
                        bool isChecked = false;
                        return Card(
                          child: ListTile(
                            title: Text(maintenanceItem.mileage.toString()),
                            subtitle: Column(
                              children: [
                                Text(
                                  (maintenanceItem.expectedDate).toString(),
                                ),
                                // SizedBox(height: 4),
                                // Text(maintenanceItem.description),
                                // Gesture detector, redirects to details page (date, description, image)
                              ],
                            ),
                            trailing: Checkbox(
                              value: isChecked,
                              onChanged: (bool? isDone) {
                                setState(() {
                                  isChecked = isDone!;
                                  //logic to move it to history
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: maintenanceController,
                  decoration: InputDecoration(
                    hintText: 'Enter Maintenance Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  NotiService().showNotification(
                    title: 'Maintenance Added!',
                    body: maintenanceController.text,
                  );
                  firestoreService
                      .addMaintenanceList(maintenanceController.text);
                },
                child: Text('Add Maintenance'),
              ),

SizedBox(height: 20,),
              // AddMaintenancescreen
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AddMaintenance(),
                      ));
                },
                child: Text('Add Maintenance screen '),
              )
            ],
          ),
          // Maintenance History Tab: maybe we add a list builder pulling from the history local db
          Center(child: Text('No history yet.')),

        ]),
      ),
    );
  }
}
