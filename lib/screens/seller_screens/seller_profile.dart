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
      body: Stack(
        children: [
          Container(
            width: 393,
            height: 250,
            decoration: ShapeDecoration(
              color: AppColors.secondaryText,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: const Color(0xFFE3E3E3),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: _profileImage != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(_profileImage!),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.secondaryText,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                ),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  '${seller.email}',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 60,
                ),
                ProfileOptionTile(
                  rightIcon: Icons.person,
                  text: 'Profile',
                  onBackTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerAccountManagement()),
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                ProfileOptionTile(
                  rightIcon: Icons.settings,
                  text: 'MyStores',
                  onBackTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyStores()),
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                ProfileOptionTile(
                  rightIcon: Icons.settings,
                  text: 'Settings',
                  onBackTap: () {},
                ),
                SizedBox(
                  height: 15,
                ),
                ProfileOptionTile(
                  rightIcon: Icons.history,
                  text: 'Activity',
                  onBackTap: () {},
                ),
                SizedBox(
                  height: 15,
                ),
                ProfileOptionTile(
                  rightIcon: Icons.security,
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
                // SizedBox(
                //   height: 15,
                // ),
                // ProfileOptionTile(
                //   rightIcon: Icons.help_outline,
                //   text: 'Help & Support',
                //   onBackTap: () {},
                // ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: buildButton(
                    'Log Out',
                    AppColors.buttonColor,
                    AppColors.buttonText,
                    onPressed: () {
                      AuthService().signOut(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
