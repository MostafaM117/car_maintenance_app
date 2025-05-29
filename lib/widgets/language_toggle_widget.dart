import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'custom_widgets.dart';

class LanguageToggle extends StatefulWidget {
  final bool isEnglish;
  final Function(bool) onToggle;

  const LanguageToggle({
    super.key,
    required this.isEnglish,
    required this.onToggle,
  });

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  late bool _isEnglish;

  @override
  void initState() {
    super.initState();
    _isEnglish = widget.isEnglish;
  }

  void _toggleLanguage(bool english) {
    setState(() {
      _isEnglish = english;
      widget.onToggle(_isEnglish);
      // Update the actual language using LanguageProvider
      final languageProvider =
          Provider.of<LanguageProvider>(context, listen: false);
      languageProvider.setLanguage(english ? 'en' : 'ar');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            Row(
              children: [
                Text(
                  l10n.language,
                  style: textStyleGray.copyWith(
                    fontSize: 14,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
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
                        color: !_isEnglish ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Text(l10n.arabicLanguage,
                          style: TextStyle(
                            color: !_isEnglish ? Colors.white : Colors.black,
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _toggleLanguage(true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isEnglish ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Text(
                        l10n.englishLanguage,
                        style: TextStyle(
                          color: !_isEnglish ? Colors.black : Colors.white,
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
