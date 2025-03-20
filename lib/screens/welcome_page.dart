import 'package:car_maintenance/screens/Auth%20&%20Account%20Management/auth_page.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_widgets.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              Positioned(
                left: -screenWidth * 0.2,
                top: screenHeight * 0.2,
                child: Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.4,
                  decoration: ShapeDecoration(
                    color: AppColors.buttonColor,
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.22,
                child: Image.asset(
                  "assets/images/Hyundai.png",
                  width: screenWidth * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.68,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Cars',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: screenWidth * 0.09,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Enjoy the luxury',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: screenWidth * 0.09,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ), Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.160,
                vertical: screenHeight * 0.01,
              ),
              margin: EdgeInsets.only(
                bottom: screenHeight * 0.05,
              ),
              child: buildButton(
                'Get Started',
                AppColors.buttonColor,
                AppColors.buttonText,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthPage()),
                  );
                },
              ),
            ),
          ),
            ],
          ),
        );
  }
}
