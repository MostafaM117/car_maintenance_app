import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'mileage_display.dart';

class CarCard extends StatelessWidget {
  final String carName;
  final String carId;
  final String odometer;
  final int year;
  final int mileage;
  final int avgKmPerMonth;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onCardPressed;

  const CarCard({
    Key? key,
    required this.carName,
    required this.carId,
    required this.odometer,
    required this.year,
    required this.mileage,
    required this.avgKmPerMonth,
    this.onDeletePressed,
    this.onCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardPressed,
      child: SizedBox(
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
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 20,
                        child: MileageDisplay(
                          carId: carId,
                          currentMileage: mileage,
                          avgKmPerMonth: avgKmPerMonth,
                          onMileageUpdated: (newMileage) {
                            print(
                                'Updated mileage for car $carId: $newMileage');
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: onDeletePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Delete Car',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
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
}
