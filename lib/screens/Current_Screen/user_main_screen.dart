import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_maintenance/screens/user_screens/home_page.dart';
import 'package:car_maintenance/screens/user_screens/maintenance.dart';
import 'package:car_maintenance/screens/user_screens/market.dart';
import 'package:car_maintenance/screens/user_screens/profile.dart';
// import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../AI-Chatbot/chatbot.dart';
import '../../services/ltutorial_service.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const MaintenanceScreen(),
    Chatbot(userId: FirebaseAuth.instance.currentUser!.uid),
    Market(),
    Profile(),
  ];

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _maintainKey = GlobalKey();
  final GlobalKey _chatKey = GlobalKey();
  final GlobalKey _marketKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initTutorial();
    });
  }

  Future<void> _initTutorial() async {
    final tutorialService = TutorialService();

    tutorialService.init(
      context: context,
      keys: [_homeKey, _maintainKey, _chatKey, _marketKey, _profileKey],
      texts: [
        S.of(context).tutorialHome,
        S.of(context).tutorialMaintain,
        S.of(context).tutorialChatbot,
        S.of(context).tutorialMarket,
        S.of(context).tutorialProfile,
      ],
    );

await TutorialService().showTutorial(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _icons = [
    'assets/svg/home.svg',
    'assets/svg/wrench2.svg',
    'assets/svg/chat.svg',
    'assets/svg/shop.svg',
    'assets/svg/user.svg',
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> labels = [
      S.of(context).home,
      S.of(context).maintain,
      S.of(context).chatbot,
      S.of(context).market,
      S.of(context).account,
    ];

    final List<GlobalKey> keys = [
      _homeKey,
      _maintainKey,
      _chatKey,
      _marketKey,
      _profileKey,
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryText,
          borderRadius: BorderRadius.circular(25),
        ),
        child: GNav(
          backgroundColor: AppColors.primaryText,
          color: Colors.white,
          activeColor: Colors.white,
          gap: 5,
          tabBorderRadius: 22,
          onTabChange: _onItemTapped,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          tabs: List.generate(
            labels.length,
            (index) => GButton(
              key: keys[index],
              icon: Icons.circle,
              leading: _selectedIndex == index
                  ? const SizedBox.shrink()
                  : SvgPicture.asset(
                      _icons[index],
                      height: 25,
                      width: 25,
                      color: Colors.white,
                    ),
              text: labels[index],
              backgroundColor: AppColors.buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}
