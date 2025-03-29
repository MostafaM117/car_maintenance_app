import 'package:car_maintenance/models/CarData.dart';
// import 'package:car_maintenance/forms/carform.dart';
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
    firestoreService = FirestoreService(CarData());
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
          Expanded(
            child: StreamBuilder<List<MaintenanceList>>(
              stream: firestoreService.getMaintenanceList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }
                final maintList = snapshot.data!;
                //debug print
                if (maintList.isEmpty) {
                  print("Maintenance list is empty!");
                  return Center(
                      child: Text("No maintenance records available."));
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
          ),
          // add special case maintenance? to be tweaked
          Column(
            children: [
              TextField(
                controller: maintenanceController,
                decoration: InputDecoration(
                  hintText: 'Enter Maintenance Description',
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
            ],
          ),
        ]),
      ),
    );
  }
}
