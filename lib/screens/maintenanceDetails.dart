import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/models/maintenanceModel.dart';

import '../widgets/BackgroundDecoration.dart';
import '../widgets/maintenance_card.dart';

class MaintenanceDetailsPage extends StatelessWidget {
  final MaintenanceList maintenanceItem;

  const MaintenanceDetailsPage({super.key, required this.maintenanceItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const CurvedBackgroundDecoration(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Center(
                    child: Text(
                      "Maintenance",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buildMaintenanceCard(
                    title: "Mileage: ${maintenanceItem.mileage}",
                    date: maintenanceItem.expectedDate
                        .toLocal()
                        .toString()
                        .split(' ')[0],
                    tasks: [
                      "Description: ",
                      maintenanceItem.description,
                      "Completed: ${maintenanceItem.isDone ? 'Yes' : 'No'}",
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
