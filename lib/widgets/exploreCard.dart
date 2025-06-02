// explore_card.dart
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ExploreCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ExploreCard({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        height: 95,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.borderSide,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/covers/Screens_cover.png',
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 45, left: 5,right: 5),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
