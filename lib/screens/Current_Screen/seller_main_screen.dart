import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/seller_screens/seller_home_page.dart';
import 'package:car_maintenance/screens/seller_screens/seller_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../seller_screens/seller_market.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({super.key});

  @override
  _SellerMainScreenState createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SellerHomePage(),
    MarketPage(),
    SellerProfile(),
  ];

  final List<String> _labels = [
    'Home',
    'Market',
    'Profile',
  ];

  final List<String> _icons = [
    'assets/svg/home.svg',
    'assets/svg/shop.svg',
    'assets/svg/user.svg',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          tabs: List.generate(
            _labels.length,
            (index) => GButton(
              icon: Icons.circle,
              leading: _selectedIndex == index
                  ? const SizedBox.shrink()
                  : SvgPicture.asset(
                      _icons[index],
                      height: 25,
                      width: 25,
                      color: Colors.white,
                    ),
              text: _labels[index],
              backgroundColor: AppColors.buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}
