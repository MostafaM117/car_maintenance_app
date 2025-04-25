import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'mycar_mileage_display.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onCardPressed,
      child: SizedBox(
        width: screenWidth * 0.85,
        height: screenHeight * 0.20,
        child: Card(
          color: AppColors.secondaryText,
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
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              carName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.buttonColor,
                              ),
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
                    MyCarMileageDisplay(
                      mileage: mileage,
                      avgKmPerMonth: avgKmPerMonth,
                    ),
                    popUpBotton(
                      'Delete Car',
                      AppColors.buttonColor,
                      AppColors.buttonText,
                      onPressed: onDeletePressed,
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
