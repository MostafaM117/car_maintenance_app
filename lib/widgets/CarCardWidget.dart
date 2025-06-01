// import 'package:car_maintenance/models/MaintID.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/widgets/car_image_widget.dart';
import 'package:flutter_svg/svg.dart';
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
    final int mileage = car['mileage'] is double
        ? (car['mileage'] as double).toInt()
        : car['mileage'] as int? ?? 0;
    return Directionality(
      textDirection: TextDirection.ltr, // هنا ثبت الاتجاه
      child: Card(
        color: AppColors.secondaryText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CarImageWidget(
              make: make,
              model: model,
              year: year,
              width: 180,
              height: 100, //95
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 10.0),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$make $model',
                                style: textStyleWhite.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$year',
                                style: textStyleGray,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'Mileage: ',
                                  style: textStyleWhite.copyWith(
                                    fontSize: 16),
                                  children: [
                                    TextSpan(
                                        text: mileage.toString(),
                                        style: textStyleGray),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  MileageDisplay.showMileageEditDialog(
                                    context,
                                    carId,
                                    mileage,
                                    onMileageUpdated: (newMileage) {
                                      print(
                                          'Updated mileage for car $carId: $newMileage');
                                    },
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/svg/edit.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Car ID',
                            style: textStyleWhite.copyWith(
                                    fontSize: 16),
                          ),
                          Text(
                            carId
                                .toString()
                                .substring(carId.toString().length - 4),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    //);
  }
}
