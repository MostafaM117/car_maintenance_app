import 'package:flutter/material.dart';
import 'package:car_maintenance/models/offer_model.dart';
import 'package:car_maintenance/Back-end/offer_service.dart';

class UserFeedScreen extends StatelessWidget {
  final OfferService offerService = OfferService();

  UserFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Offers')),
      body: StreamBuilder<List<Offer>>(
        stream: offerService.getOffers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error loading offers');
          if (!snapshot.hasData) return CircularProgressIndicator();

          final offers = snapshot.data!;
          if (offers.isEmpty) return Text('No offers available.');

          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: ListTile(
                  title: Text(offer.title),
                  subtitle: Text('${offer.description}\n'
                      'Seller: ${offer.business_name}\n'
                      'Original Price: \$${offer.originalPrice}\n'
                      'Discount: ${offer.discountPercentage}%\n'
                      'Price After Discount: \$${offer.priceAfterDiscount}\n'
                      'Valid Until: ${offer.validUntil.toLocal().toString().split(' ')[0]}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
