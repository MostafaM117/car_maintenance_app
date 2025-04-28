import 'package:flutter/material.dart';

class MyCarMileageDisplay extends StatelessWidget {
  final int mileage;
  final int avgKmPerMonth;

  const MyCarMileageDisplay({
    Key? key,
    required this.mileage,
    required this.avgKmPerMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Avg: $avgKmPerMonth km/month',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          'Mileage: $mileage km',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const Text(
          'Click card to edit',
          style: TextStyle(
            fontSize: 10,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
