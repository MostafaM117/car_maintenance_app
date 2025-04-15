import 'package:flutter/material.dart';
import 'package:car_maintenance/widgets/car_image_widget.dart';
import '../constants/app_colors.dart';
import 'custom_widgets.dart';
import 'package:car_maintenance/widgets/mileage_display.dart';

class CarCardWidget extends StatelessWidget {
  final Map<String, dynamic> car;
  const CarCardWidget({Key? key, required this.car}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String? make = car['make'];
    String? model = car['model'];
    int? year = car['year'];
    String carId = car['id'];
    
    return Card(
      color: AppColors.secondaryText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarImageWidget(
            make: make,
            model: model,
            year: year,
            width: 230,
            height: 95, 
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$make $model',
                          style: textStyleWhite,
                        ),
                        Text(
                          '$year',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Car ID',
                          style: textStyleWhite,
                        ),
                        Text(
                          carId.toString().substring(carId.toString().length - 4),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8), 
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 22,
                      child: MileageDisplay(
                        carId: carId,
                        currentMileage: car['mileage'] ?? 0,
                        avgKmPerMonth: car['avgKmPerMonth'] ?? 0,
                        onMileageUpdated: (newMileage) {
                          print('Updated mileage for car $carId: $newMileage');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}