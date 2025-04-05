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

  @override
  void initState() {
    super.initState();
    firestoreService = FirestoreService(MaintID());
  }

  final TextEditingController maintenanceController = TextEditingController();

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
                  firestoreService.addMaintenanceList(maintenanceController.text);
                },
                child: Text('Add Maintenance'),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
