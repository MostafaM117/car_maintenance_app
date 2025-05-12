import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
// import '../widgets/BackgroundDecoration.dart';
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
          // const CurvedBackgroundDecoration(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 50),
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
                  Column(
                    children: [
                      Container(
                        height: 40,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF4F4F4),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: AppColors.borderSide,
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: TextField(
                          controller: TextEditingController(),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterButton('Price'),
                            const SizedBox(width: 8),
                            _buildFilterButton('Location'),
                            const SizedBox(width: 8),
                            _buildFilterButton('Filter'),
                            const SizedBox(width: 8),
                            _buildFilterButton('Filter'),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildFilterButton(String title) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: AppColors.secondaryText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(title),
    );
  }
}
