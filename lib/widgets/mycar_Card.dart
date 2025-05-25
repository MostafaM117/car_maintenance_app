
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
// import 'mycar_mileage_display.dart';

class CarCard extends StatelessWidget {
  final String carName;
  final String carId;
  final String odometer;
  final int year;
  final int mileage;
  final int avgKmPerMonth;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onEditPressed;

  const CarCard({
    super.key,
    required this.carName,
    required this.carId,
    required this.odometer,
    required this.year,
    required this.mileage,
    required this.avgKmPerMonth,
    this.onDeletePressed,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onEditPressed,
      child: SizedBox(
        width: screenWidth * 0.85,
        height: screenHeight * 0.23,
        child: Card(
          color: AppColors.secondaryText,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 13, left: 13, right: 13, bottom: 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              carName,
                              style: textStyleWhite.copyWith(
                                  color: AppColors.buttonColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(year.toString(),
                              textAlign: TextAlign.justify,
                              style: textStyleWhite.copyWith(
                                fontWeight: FontWeight.w300,
                              )),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text("Car ID", style: textStyleWhite),
                        Text(carId.substring(carId.length - 4),
                            style: textStyleGray),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Mileage: ',
                        style: textStyleWhite,
                        children: [
                          TextSpan(
                              text: mileage.toString(), style: textStyleGray),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Average: ',
                        style: textStyleWhite,
                        children: [
                          TextSpan(
                              text: avgKmPerMonth.toString(),
                              style: textStyleGray),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: onDeletePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text("Delete",
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: onEditPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text("Edit",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
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

