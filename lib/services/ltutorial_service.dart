import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../generated/l10n.dart';

class TutorialService {
  // Singleton instance
  static final TutorialService _instance = TutorialService._internal();

  factory TutorialService() => _instance;

  TutorialService._internal();

  late List<TargetFocus> _targets;

  void init({
    required BuildContext context,
    required List<GlobalKey> keys,
    required List<String> texts,
  }) {

    _targets = List.generate(keys.length, (index) {
      return TargetFocus(
        keyTarget: keys[index],
        identify: 'Target $index',
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Text(
              texts[index],
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      );
    });
  }

  // Future<void> showTutorial({bool forceShow = false}) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final shown = prefs.getBool('tutorialShown') ?? false;

  //   if (!shown || forceShow) {
  //     TutorialCoachMark(
  //       targets: _targets,
  //       colorShadow: Colors.black,
  //       textSkip: S.of(_context).skip,
  //       opacityShadow: 0.8,
  //     ).show(context: _context);

  //     if (!shown) {
  //       await prefs.setBool('tutorialShown', true);
  //     }
  //   }

  Future<void> showTutorial(BuildContext context,
      {bool forceShow = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('tutorialShown') ?? false;

    if (!shown || forceShow) {
      TutorialCoachMark(
        targets: _targets,
        colorShadow: Colors.black,
        textSkip: S.of(context).skip, // استخدم context الحالي هنا
        opacityShadow: 0.8,
      ).show(context: context);

      if (!shown) {
        await prefs.setBool('tutorialShown', true);
      }
    }
  }
}
