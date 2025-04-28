import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'custom_widgets.dart';

class StoreCard extends StatelessWidget {
  final String storeName;
  final String taxNumber;
  final String storeNumber;
  final String locationDetails;
  // final VoidCallback? onDeletePressed;

  const StoreCard({
    super.key,
    required this.storeName,
    required this.taxNumber,
    required this.storeNumber,
    required this.locationDetails,
    // this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.85,
      height: screenHeight * 0.20,
      child: Card(
        color: AppColors.secondaryText,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            storeName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.buttonColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          taxNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    storeNumber,
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
                  Text(
                    locationDetails,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryText,
                    ),
                  ),
                  popUpBotton(
                    'Delete Store ',
                    AppColors.buttonColor,
                    AppColors.buttonText,
                    onPressed: () {},
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
