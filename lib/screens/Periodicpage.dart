import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/BackgroundDecoration.dart';
import '../widgets/ProductCard.dart';

class Periodicpage extends StatelessWidget {
  const Periodicpage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  Center(
                    child: Text(
                      "Periodic",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilterChipWidget(label: 'Price'),
                        FilterChipWidget(label: 'Location'),
                        FilterChipWidget(label: 'Filter'),
                        FilterChipWidget(label: 'Filter'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.80,
                      children: [
                        ProductCard(
                          image: 'assets/images/motor_oil.png',
                          title: 'Motor Oil',
                          price: '420 ',
                        ),
                        ProductCard(
                          image: 'assets/images/motor_oil.png',
                          title: 'Motor Oil',
                          price: '350 ',
                        ),
                        ProductCard(
                          image: 'assets/images/motor_oil.png',
                          title: 'motor oil',
                          price: '350 ',
                        ),
                        ProductCard(
                          image: 'assets/images/motor_oil.png',
                          title: 'motor oil',
                          price: '350 ',
                        ),
                      ],
                    ),
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
