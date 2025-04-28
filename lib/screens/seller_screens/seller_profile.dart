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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SizedBox(height: 10),
                    Text(
                      "Account",
                      style: textStyleWhite.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 9.20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 393,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.only(
                              left: 100, top: 20, bottom: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(username, style: textStyleWhite),
                              SizedBox(height: 5),
                              Text('${seller.email}', style: textStyleGray),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 15,
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            width: 100,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              image: _profileImage != null
                                  ? DecorationImage(
                                      image: FileImage(_profileImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _profileImage == null
                                ? Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          ProfileOptionTile(
                            rightIcon: Icons.person,
                            text: 'Profile',
                            onBackTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SellerAccountManagement()),
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
                                MaterialPageRoute(
                                    builder: (context) => MyStores()),
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
                                  builder: (context) =>
                                      TermsAndConditionsPage(),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ProfileOptionTile(
                            rightIcon: Icons.logout,
                            text: 'Log Out',
                            onBackTap: () {
                              AuthService().signOut(context);
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
