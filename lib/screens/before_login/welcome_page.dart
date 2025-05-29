import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_widgets.dart';
import 'login_type.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Language Switch Button
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
                languageProvider.setLanguage(isArabic ? 'en' : 'ar');
              },
            ),
          ),
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
              left: isArabic ? 0 : screenWidth * 0.1,
              right: isArabic ? screenWidth * 0.1 : 0,
              top: screenHeight * 0.68,
            ),
            child: Column(
              crossAxisAlignment:
                  isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeToMotorgy,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  l10n.appDescription,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w300,
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
                l10n.getStarted,
                AppColors.buttonColor,
                AppColors.buttonText,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginType()),
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
