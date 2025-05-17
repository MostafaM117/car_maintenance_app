import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

import '../screens/ProductDetailsPage.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String description;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              image: image,
              title: title,
              price: price,
              description: description,
            ),
          ),
        );
      },
      child: Container(
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
              child: Image.asset(
                image,
                height: 100,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.only(
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
                      style:
                          textStyleWhite.copyWith(color: AppColors.buttonText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$price LE',
                      style: textStyleGray.copyWith(
                          color: AppColors.borderSide,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final String? highlight;

  const InfoCard({
    required this.title,
    required this.content,
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 3, bottom: 10, left: 15, right: 15),
      decoration: BoxDecoration(
        color: AppColors.secondaryText,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: textStyleGray.copyWith(
                  fontSize: 18, color: AppColors.primaryText)),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: content, style: textStyleWhite),
                if (highlight != null)
                  TextSpan(
                      text: '\n$highlight',
                      style: textStyleGray.copyWith(
                          color: AppColors.buttonColor, fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
