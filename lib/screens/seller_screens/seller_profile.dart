import 'dart:io';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/seller_account_management.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/auth_service.dart';
import 'package:car_maintenance/screens/Terms_and_conditionspage%20.dart';
import 'package:car_maintenance/screens/seller_screens/my_stores.dart';
import 'package:car_maintenance/services/seller/seller_data_helper.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/darkmode_toggle_widget.dart';
import '../../widgets/language_toggle_widget.dart';
import '../../widgets/profile_option_tile.dart.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({super.key});

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  String username = 'Loading...';
  final seller = FirebaseAuth.instance.currentUser!;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('sellers');
  File? _profileImage;
  bool isEnglish = true;
  bool isDarkMode = false;
  @override
  void initState() {
    super.initState();
    loadSellername();
    _loadImage();
  }

  void _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImagePath');
    if (imagePath != null) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  void loadSellername() async {
    String? fetchedUsername = await getSellername();
    if (!mounted) return;
    setState(() {
      username = fetchedUsername ?? 'seller';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: _profileImage != null
                      ? ClipOval(
                          child: Image.file(
                            _profileImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  '${seller.email}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    ProfileOptionTile(
                      text: 'Profile',
                      onBackTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SellerAccountManagement(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileOptionTile(
                      text: 'MyStores',
                      onBackTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyStores(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    LanguageToggle(
                      isEnglish: isEnglish,
                      onToggle: (value) {
                        setState(() => isEnglish = value);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DarkModeToggle(
                      isDarkMode: isDarkMode,
                      onChanged: (value) {
                        setState(() => isDarkMode = value);
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileOptionTile(
                      text: 'Terms & Conditions',
                      onBackTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsAndConditionsPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
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
            ),
          ],
        ),
      ),
    );
  }
}
