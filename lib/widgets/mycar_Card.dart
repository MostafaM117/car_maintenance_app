import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'custom_widgets.dart';

Widget buildCarCard({
  required BuildContext context,
  required String carName,
  required String carId,
  required String odometer,
  VoidCallback? onDeletePressed,
}) {
  return Container(
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
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, 
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  carName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  carId,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  odometer,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 40,
                  width: 142,
                  child: buildButton(
                    'Delete Car',
                    AppColors.buttonColor,
                    Colors.white,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
