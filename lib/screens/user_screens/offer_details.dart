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
    );
  }
}
