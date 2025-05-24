import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/auth_service.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class StoreNotVerified extends StatelessWidget {
  const StoreNotVerified({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text('Please wait until our team review your account, and you will recieve an email shortly.'),
              ),
            ),
            buildButton(
              'Log Out',
            AppColors.buttonColor,
            AppColors.buttonText,
              onPressed: () async {
                await AuthService().signOut(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}