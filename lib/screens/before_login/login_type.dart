import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/seller_auth_page.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/user/user_auth_page.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/app_colors.dart';
import '../../widgets/BackgroundDecoration.dart';

class LoginType extends StatelessWidget {
  const LoginType({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CurvedBackgroundDecoration(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 120,
                        ),
                        LocalizedText(
                          text: l10n.letsGetStarted,
                          style: textStyleWhite.copyWith(
                              fontSize: 28, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 10),
                        LocalizedText(
                          text: l10n.welcomeDescription,
                          style: textStyleGray.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      children: [
                        buildButton(
                          l10n.account,
                          AppColors.buttonColor,
                          AppColors.buttonText,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserAuthPage()),
                            );
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buildButton(
                          l10n.seller,
                          AppColors.buttonColor,
                          AppColors.buttonText,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SellerAuthPage()),
                            );
                          },
                        ),
                      ],
                    ),
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
