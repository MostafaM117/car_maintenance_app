import 'package:flutter/material.dart';
import '../services/car_image_service.dart';

class CarImageWidget extends StatelessWidget {
  final String? make;
  final String? model;
  final int? year;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color fallbackIconColor;
  final double fallbackIconSize;

  const CarImageWidget({
    Key? key,
    required this.make,
    required this.model,
    required this.year,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallbackIconColor = Colors.grey,
    this.fallbackIconSize = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarImageService.getCarImageWidget(
      make,
      model,
      year,
      width: width,
      height: height,
      fit: fit,
      fallbackIconColor: fallbackIconColor,
      fallbackIconSize: fallbackIconSize,
    );
  }
} 