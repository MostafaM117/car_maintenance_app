import 'package:car_maintenance/screens/user_screens/offer_details.dart';
import 'package:car_maintenance/widgets/offercard.dart';
import 'package:flutter/material.dart';
import 'package:car_maintenance/models/offer_model.dart';
import 'package:car_maintenance/Back-end/offer_service.dart';

import '../../constants/app_colors.dart';

class UserFeedScreen extends StatelessWidget {
  final OfferService offerService = OfferService();

  UserFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Offers",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Offer>>(
                stream: offerService.getOffers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading offers'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final offers = snapshot.data!;
                  if (offers.isEmpty) {
                    return const Center(child: Text('No offers available.'));
                  }

                  return ListView.builder(
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OfferDetailsScreen(
                                imageUrl: offer.imageUrl,
                                title: offer.title,
                                description: offer.description,
                                price: '${offer.priceAfterDiscount} ',
                                discount: '${offer.discountPercentage}%',
                                validTo: offer.validUntil
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                                shopName: offer.business_name,
                                shopPhone: 'shopPhone',
                                shopLocation: 'shopLocation',
                              ),
                            ),
                          );
                        },
                        child: UserOfferCard(
                          title: offer.title,
                          discount: '${offer.discountPercentage}%',
                          sellerName: offer.business_name,
                          date:
                              'Valid Until: ${offer.validUntil.toLocal().toString().split(' ')[0]}',
                          imageUrl: (offer.imageUrl.isNotEmpty)
                              ? offer.imageUrl
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
