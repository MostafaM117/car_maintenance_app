import 'package:android_intent_plus/android_intent.dart';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/custom_widgets.dart';
// import 'package:car_maintenance/constants/app_colors.dart';

class OfferDetailsScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final String discount;
  final String validTo;
  final String shopName;
  final String shopPhone;
  final String shopLocation;

  const OfferDetailsScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.discount,
    required this.validTo,
    required this.shopName,
    required this.shopPhone,
    required this.shopLocation,
  });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl,
                      height: 200, width: double.infinity, fit: BoxFit.cover)
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: Text("No Image")),
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                Text(
                  "$price LE",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text("About Offer Name",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 16),
            const Text("Availability",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Valid Until: $validTo',
              style: textStyleGray,
            ),
            const SizedBox(height: 16),
            const Text("About Seller Market",
                style: TextStyle(fontWeight: FontWeight.bold)),
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
                    "Phone: 0 100 709 8944",
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
                    child: Row(
                  children: [
                    Text(
                      textAlign: TextAlign.left,
                      'Shop Location: ',
                      style: textStyleGray.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () {
                        openGoogleSearch(30.0414805, 30.9839595);
                      },
                    ),
                  ],
                )),
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
    );
  }
}
