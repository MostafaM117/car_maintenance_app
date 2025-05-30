import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/custom_widgets.dart';

class ProductDetailsPage extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String description;
final String shopName;
  final String shopPhone;
  final String shopLocation;
  const ProductDetailsPage({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.shopName,
    required this.shopPhone,
    required this.shopLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 393,
              height: 240,
              decoration: ShapeDecoration(
                color: AppColors.primaryText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              child: Image.asset(image, height: 200),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonColor),
                ),
                Text('$price LE', style: const TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Availability ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'In Stock',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Item Name',
                    style: textStyleWhite.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    description,
                    style: textStyleGray.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'About Seller Market',
                    style: textStyleWhite.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Name: $shopName",
                          style: textStyleGray,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/shopname.svg',
                        width: 20,
                        height: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Phone: $shopPhone",
                          style: textStyleGray,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/shopphone.svg',
                        width: 20,
                        height: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Location: $shopLocation",
                          style: textStyleGray,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/svg/shoplocation.svg',
                        width: 20,
                        height: 20,
                        color: Colors.grey,
                      ),
                    ],
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
