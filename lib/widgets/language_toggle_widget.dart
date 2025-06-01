import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../providers/locale_provider.dart';
import 'custom_widgets.dart'; // استيراد الـ Provider

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    bool isEnglish = localeProvider.locale.languageCode == 'en';

    void _toggleLanguage(bool english) {
      Locale newLocale = english ? const Locale('en') : const Locale('ar');
      localeProvider.setLocale(newLocale);
    }

    return Container(
      width: 320,
      height: 55,
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F4F4),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.borderSide,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).language,
              style: textStyleGray.copyWith(
                fontSize: 14,
                color: AppColors.primaryText,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _toggleLanguage(false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: !isEnglish ? Colors.red : Colors.transparent,
                        borderRadius: !isEnglish
                            ? const BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )
                            : const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        "ع",
                        style: TextStyle(
                          color: !isEnglish ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _toggleLanguage(true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isEnglish ? Colors.red : Colors.transparent,
                        borderRadius: !isEnglish
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              )
                            : const BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        "Eng",
                        style: TextStyle(
                          color: !isEnglish ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
