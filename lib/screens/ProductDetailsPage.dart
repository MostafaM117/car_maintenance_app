import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../widgets/ProductCard.dart';

class ProductDetailsPage extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String description;

  const ProductDetailsPage({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
        child: Column(
          children: [
            Container(
              width: 393,
              height: 240,
              decoration: ShapeDecoration(
                color: AppColors.primaryText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              child: Image.asset(image, height: 200),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonColor),
                ),
                Text('$price LE', style: const TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            // وصف المنتج
            InfoCard(
              title: 'Description',
              content: description,
            ),
            const SizedBox(height: 30),

            // مكان التوفر
            InfoCard(
              title: 'Available In',
              content:
                  'Nacita Autocare Zayed 2 - Dahshour Branch.\nChill Out Station on Dahshour Link Road, facing Zayed entrance 3',
              highlight: '19725',
            ),
          ],
        ),
      ),
    );
  }
}
