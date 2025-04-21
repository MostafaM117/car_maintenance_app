import 'package:flutter/material.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';

class MaintenanceDetailsPage extends StatelessWidget {
  final MaintenanceList maintenanceItem;

  const MaintenanceDetailsPage({super.key, required this.maintenanceItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Maintenance Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mileage: ${maintenanceItem.mileage}",
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text(
                "Expected Date: ${maintenanceItem.expectedDate.toLocal().toString().split(' ')[0]}"),
            SizedBox(height: 8),
            Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(maintenanceItem.description),
            SizedBox(height: 8),
            Text("Periodic: ${maintenanceItem.periodic ? 'Yes' : 'No'}"),
          ],
        ),
      ),
    );
  }
}
