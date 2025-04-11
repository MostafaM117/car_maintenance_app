import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../widgets/BackgroundDecoration.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/mycar_Card.dart';
import 'formscreens/formscreen1.dart';

class CarMaint extends StatefulWidget {
  const CarMaint({super.key});

  @override
  State<CarMaint> createState() => _CarMaintState();
}

class _CarMaintState extends State<CarMaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CurvedBackgroundDecoration(), 
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 70),
                  Text(
                    "My Cars",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  buildCarCard(
                    context: context,
                    carName: 'Toyota Corolla',
                    carId: 'ID/ 20059',
                    odometer: '31,500 KM',
                    // onDeletePressed: () {
                    //   print('Car deleted');
                    // },
                  ),
                  buildButton(
                    'Add Car',
                    AppColors.buttonColor,
                    AppColors.secondaryText,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddCarScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
