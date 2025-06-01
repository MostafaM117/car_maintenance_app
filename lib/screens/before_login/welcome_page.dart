import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/generated/l10n.dart';
import 'package:car_maintenance/screens/before_login/login_type.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/locale_provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final localeProvider = Provider.of<LocaleProvider>(context);
    bool isArabic = localeProvider.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.05,
            child: IconButton(
              icon: Text(
                isArabic ? 'EN' : 'AR',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Locale newLocale = isArabic ? Locale('en') : Locale('ar');
                localeProvider.setLocale(newLocale);
              },
            ),
          ),
          // باقي تصميم الصفحة
          Positioned(
            left: isArabic ? null : -screenWidth * 0.2,
            right: isArabic ? -screenWidth * 0.2 : null,
            top: screenHeight * 0.2,
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.4,
              decoration: ShapeDecoration(
                color: AppColors.lightGray,
                shape: OvalBorder(),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.22,
            left: isArabic ? null : 0,
            right: isArabic ? 0 : null,
            child: Image.asset(
              isArabic
                  ? "assets/images/Hyundair.png"
                  : "assets/images/Hyundai.png",
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
              crossAxisAlignment:
                  isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).welcome,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  S.of(context).welcomedis,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Align(
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
                S.of(context).get_started,
                AppColors.buttonColor,
                AppColors.buttonText,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginType()),
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
