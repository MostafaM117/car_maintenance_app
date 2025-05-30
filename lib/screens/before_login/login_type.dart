import 'package:car_maintenance/generated/l10n.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/seller_auth_page.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/user/user_auth_page.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../widgets/BackgroundDecoration.dart';

class LoginType extends StatelessWidget {
  const LoginType({super.key});

  @override
  Widget build(BuildContext context) {

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
                          height: 100,
                        ),
                        Text(
                          S.of(context).get_started,
                          style: textStyleWhite.copyWith(
                              fontSize: 28, fontWeight: FontWeight.w800),
                          
                        ),
                        const SizedBox(height: 10),
                        Text(
                          S.of(context).get_starteddis,
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
                          S.of(context).car_owner,
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
                          S.of(context).parts_seller,
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
