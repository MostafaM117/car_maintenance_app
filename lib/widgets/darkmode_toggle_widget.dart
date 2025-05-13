import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'custom_widgets.dart';

class DarkModeToggle extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onChanged;

  const DarkModeToggle({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
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
            color: AppColors.borderSide,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Dark Mode",
              style: textStyleGray.copyWith(
                fontSize: 14,
                color: AppColors.primaryText,
              ),
            ),
            Container(
              width: 65,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                alignment: Alignment.center, // Center alignment vertically
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    left: isDarkMode ? 32 : 2,
                    child: Container(
                      width: 30,
                      height: 25,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.buttonColor
                            : Colors.grey[500],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onChanged(!isDarkMode),
                    child: Container(
                      width: 50,
                      height: 30,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class DarkModeToggle extends StatelessWidget {
//   final bool isDarkMode;

//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text("Dark Mood", style: TextStyle(fontSize: 16)),
//           Switch(
//             value: isDarkMode,
//             onChanged: onChanged,
//             activeColor: Colors.grey[800],
//           ),
//         ],
//       ),
//     );
//   }
