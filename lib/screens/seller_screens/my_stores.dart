import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/app_colors.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/stores_card.dart';

class MyStores extends StatefulWidget {
  const MyStores({super.key});

  @override
  State<MyStores> createState() => _MyStoresState();
}

class _MyStoresState extends State<MyStores> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    l10n.myStoresSeller,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 20),
                  StoreCard(
                    storeName: 'storeName',
                    storeNumber: 'storeNumber',
                    locationDetails: 'locationDetails',
                    taxNumber: 'taxNumber',
                  ),
                  SizedBox(height: 20),
                  buildButton(
                    l10n.addNewStoreButton,
                    AppColors.buttonColor,
                    AppColors.secondaryText,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
