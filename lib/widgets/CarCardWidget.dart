import 'package:flutter/material.dart';
import 'package:car_maintenance/widgets/car_image_widget.dart';
import '../constants/app_colors.dart';
import 'custom_widgets.dart';

class CarCardWidget extends StatelessWidget {
  final Map<String, dynamic> car;

  const CarCardWidget({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? make = car['make'];
    String? model = car['model'];
    int? year = car['year'];

    return Card(
      color: AppColors.secondaryText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarImageWidget(
            make: make,
            model: model,
            year: year,
            width: 230,
            height: 110,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
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
                      car['id'],
                      style: TextStyle(color: Colors.grey),
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
