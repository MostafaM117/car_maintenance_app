import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProgressStepsBar extends StatelessWidget {
  final int filledCount;
  final int totalCount;

  const ProgressStepsBar({
    super.key,
    required this.filledCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalCount, (index) {
        bool isFilled = index < filledCount;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              height: 50,
              decoration: ShapeDecoration(
                color: isFilled
                    ? AppColors.primaryText
                    : AppColors.secondaryText.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: isFilled
                        ? AppColors.secondaryText
                        : AppColors.secondaryText.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(80),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
