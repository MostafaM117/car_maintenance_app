import 'package:car_maintenance/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import 'custom_widgets.dart';

class LanguageToggle extends StatefulWidget {
  final bool isEnglish;
  final Function(Locale) onToggle;

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
      Locale newLocale = english ? Locale('en') : Locale('ar');
      widget.onToggle(newLocale);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  S.of(context).language,
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
                        borderRadius: !_isEnglish
                            ? BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              )
                            : BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                              ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Text("ع",
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
                          borderRadius: !_isEnglish
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                )
                              : BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                )
                                ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Text(
                        "Eng",
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
