import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'custom_widgets.dart';

class MaintenanceCard extends StatelessWidget {
  final String title;
  final String date;

  const MaintenanceCard({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Card(
        color: AppColors.secondaryText,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: textStyleWhite.copyWith(
                        color: AppColors.buttonColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Expected Date',
                    style: textStyleGray,
                  ),
                  const Spacer(),
                  Text(
                    date,
                    style: textStyleGray,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildMaintenanceCard({
  required String title,
  required String date,
  required List<String> tasks,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(vertical: 10),
    width: 300,
    height: 450,
    decoration: BoxDecoration(
      color: AppColors.secondaryText,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: AppColors.borderSide),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            "assets/images/maintenance.png",
            height: 60,
            width: 60,
          ),
        ),
        SizedBox(height: 15),
        Center(
          child: LocalizedText(
            text: title,
            style: textStyleWhite.copyWith(
              color: AppColors.buttonColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LocalizedText(
              text: "Expected Date",
              style: textStyleGray,
            ),
            LocalizedText(
              text: date,
              style: textStyleGray,
            ),
          ],
        ),
        SizedBox(height: 20),
        ...tasks.map(
          (task) => LocalizedText(
            text: task,
            style: textStyleWhite,
          ),
        ),
      ],
    ),
  );
}
