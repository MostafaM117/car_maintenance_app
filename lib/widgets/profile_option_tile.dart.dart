import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class ProfileOptionTile extends StatelessWidget {
  final IconData rightIcon;
  final String text;
  final VoidCallback onBackTap;

  const ProfileOptionTile({
    super.key,
    required this.rightIcon,
    required this.text,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 55,
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F4F4),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.borderSide
          ),
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(rightIcon, color: AppColors.primaryText),
                SizedBox(width: 8),
                Text(text, style: textStyleWhite),
              ],
            ),
            GestureDetector(
              onTap: onBackTap,
              child: Icon(Icons.arrow_forward, color: AppColors.primaryText),
            ),
          ],
        ),
      ),
    );
  }
}
