// import 'package:car_maintenance/widgets/custom_widgets.dart';
// import 'package:flutter/material.dart';
// import '../constants/app_colors.dart';

// class CarCard extends StatelessWidget {
//   final String carName;
//   final String carId;
//   final String odometer;
//   final int year;
//   final int mileage;
//   final int avgKmPerMonth;
//   final VoidCallback? onDeletePressed;
//   final VoidCallback? onEditPressed;
//   final VoidCallback? onCardPressed;

//   const CarCard({
//     Key? key,
//     required this.carName,
//     required this.carId,
//     required this.odometer,
//     required this.year,
//     required this.mileage,
//     required this.avgKmPerMonth,
//     this.onDeletePressed,
//     this.onEditPressed,
//     this.onCardPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onCardPressed,
//       child: Card(
//         color: AppColors.secondaryText,
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // اسم العربية + السنة
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             carName,
//                             style: TextStyle(
//                               color: const Color(0xFFDA1F11),
//                               fontSize: 24,
//                               fontFamily: 'Inter',
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Text(
//                             year.toString(),
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: AppColors.primaryText,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//                   const Spacer(),

//                   // Car ID
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       const Text(
//                         "Car ID",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         carId.length >= 4
//                             ? carId.substring(carId.length - 4)
//                             : carId,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),
// //
//               // Mileage and Average info
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text.rich(
//                     TextSpan(
//                       text: 'Mileage: ',
//                       style: textStyleWhite,
//                       children: [
//                         TextSpan(
//                             text: mileage.toString(), style: textStyleGray),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text.rich(
//                     TextSpan(
//                       text: 'Average: ',
//                       style: textStyleWhite,
//                       children: [
//                         TextSpan(
//                             text: avgKmPerMonth.toString(),
//                             style: textStyleGray),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       // Action buttons
//                       ElevatedButton(
//                         onPressed: onDeletePressed,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           minimumSize: const Size(70, 30),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         child: const Text("Delete",
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                       const SizedBox(width: 8),
//                       ElevatedButton(
//                         onPressed: onDeletePressed,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.buttonColor,
//                           minimumSize: const Size(70, 30),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                         ),
//                         child: const Text("Edit",
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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

