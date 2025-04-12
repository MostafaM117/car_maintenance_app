import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'custom_widgets.dart';

class SubtractWave extends StatelessWidget {
  final String text;
  final String svgAssetPath;

  final dynamic onTap;

  const SubtractWave(
      {super.key,
      required this.text,
      required this.svgAssetPath,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.primaryText,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text,
              style: textStyleWhite.copyWith(color: Colors.white),
            ),
          ),
          ClipPath(
            clipper: SubtractClipper(),
            child: Container(
              width: 90,
              height: 60,
              color: AppColors.background,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30, right: 20),
                  child: Container(
                    height: 26,
                    width: 26,
                    decoration: ShapeDecoration(
                      color: AppColors.secondaryText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: onTap,
                      child: SvgPicture.asset(
                        svgAssetPath,
                        width: 20,
                        height: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubtractClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(73.5914, 21.516);
    path.cubicTo(79.1268, 10.45, 84.3541, 0, 94, 0);
    path.lineTo(0, 0);
    path.cubicTo(10.244, 0, 15.5033, 10.7154, 21.0101, 21.9351);
    path.cubicTo(27.0608, 34.2631, 33.4105, 47.2, 47, 47.2);
    path.cubicTo(60.7436, 47.2, 67.3626, 33.968, 73.5914, 21.516);
    path.close();

    final matrix4 = Matrix4.identity()..scale(0.7, 0.7);
    return path.transform(matrix4.storage);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
