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
                  const Spacer(),
                  Text(
                    date,
                    style: textStyleGray,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Expected Date',
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
