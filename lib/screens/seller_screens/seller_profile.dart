import 'dart:io';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/businessname_display.dart';
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
  bool isEnglish = true;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
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
                // Profile Picture Using Stream
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('sellers')
                        .doc(seller.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.lightGray,
                          child: CircularProgressIndicator()
                        );
                      }
                        final data = snapshot.data!.data() as Map<String, dynamic>;
                        final imageUrl = data['shop_imageUrl'] as String?;
                      if (imageUrl == null || imageUrl.isEmpty) {
                        return CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.lightGray,
                          child:
                              Icon(Icons.person, size: 60, color: Colors.grey),
                        );
                      }
                      return CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.lightGray,
                        child: ClipOval(
                          child: SizedBox(
                            width: 130,
                            height: 130,
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 8),
                BusinessnameDisplay(
                  uid: seller.uid,
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
