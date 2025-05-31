import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

class ProductDetailsPage extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String description;
  final String businessName;
  final String selectedAvailability;
  final String phoneNumber;
  final double longitude;
  final double latitude;
  late final String url;
  ProductDetailsPage({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.description,
    required this.businessName,
    required this.selectedAvailability, // Default value
    required this.phoneNumber,
    required this.longitude,
    required this.latitude,
  }) {
    url =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
  }
  void openGoogleSearch(double latitude, double longitude) {
    final intent = AndroidIntent(
      action: 'action_view',
      data:
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    intent.launch().catchError((e) {
      print("Error launching intent: $e");
    });
  }

  Future<void> _openGoogleMaps() async {
    final url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$longitude,$latitude");

    if (await canLaunchUrl(url)) {
      final launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        debugPrint("Failed to launch $url");
      }
    } else {
      debugPrint("Can't launch $url");
    }
  }

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
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/motor_oil.png',
                image: image,
                height: 100,
                width: double.infinity,
                fit: BoxFit.contain,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/motor_oil.png',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  );
                },
              ),
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
                    selectedAvailability,
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
                    'About $title',
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
                    'About this business',
                    style: textStyleWhite.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    businessName,
                    style: textStyleGray.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Shop Phone Number: $phoneNumber',
                    style: textStyleGray.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                        'Shop Location: ',
                        style: textStyleGray.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          openGoogleSearch(latitude, longitude);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Open Maps',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
