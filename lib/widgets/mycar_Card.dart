import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'custom_widgets.dart';
import 'mileage_display.dart';

Widget buildCarCard({
  required BuildContext context,
  required String carName,
  required String carId,
  required String odometer,
  required int year,
  required int mileage,
  required int avgKmPerMonth,
  VoidCallback? onDeletePressed,
  VoidCallback? onCardPressed,
}) {
  return GestureDetector(
    onTap: onCardPressed,
    child: Container(
      height: 160,
      width: 300,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        year.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    carId.substring(carId.length - 4),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
              
              Spacer(),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 22,
                    child: MileageDisplay(
                      carId: carId,
                      currentMileage: mileage,
                      avgKmPerMonth: avgKmPerMonth,
                      onMileageUpdated: (newMileage) {
                        print('Updated mileage for car $carId: $newMileage');
                      },
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 142,
                    child: buildButton(
                      'Delete Car',
                      AppColors.buttonColor,
                      Colors.white,
                      onPressed: onDeletePressed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
