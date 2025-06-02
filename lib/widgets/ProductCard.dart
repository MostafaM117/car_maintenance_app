import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String businessName;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.businessName,
  });

  @override
  Widget build(BuildContext context) {
    bool isArabic = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryText,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/logo.png',
              image: image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.contain,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: isArabic
                  ? BorderRadius.only(
                      topLeft: Radius.circular(80),
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(80),
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  style: textStyleWhite.copyWith(color: AppColors.buttonText, 
                  fontSize: 13, 
                  fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  businessName,
                  style: textStyleGray.copyWith(
                    color: AppColors.buttonText,
                    fontSize: 10
                  ),
                ),
                Text(
                  '$price LE',
                  style: textStyleGray.copyWith(
                      color: AppColors.borderSide,
                      fontWeight: FontWeight.w400
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
