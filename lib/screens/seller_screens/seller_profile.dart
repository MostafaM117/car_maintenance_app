import 'dart:io';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/seller_account_management.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/user/user_account_management.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/auth_service.dart';
import 'package:car_maintenance/screens/MyCars.dart';
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
    if(mounted){
    setState(() {
      username = fetchedUsername ?? 'seller';
    });
    }
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
                  text: 'Security & Privacy',
                  onBackTap: () {},
                ),
                SizedBox(
                  height: 15,
                ),
                ProfileOptionTile(
                  rightIcon: Icons.help_outline,
                  text: 'Help & Support',
                  onBackTap: () {},
                ),
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
      // child: Stack(
      //   alignment: Alignment.topCenter,
      //   children: [
      //     // Main container
      //     Container(
      //       margin: const EdgeInsets.only(top: 100),
      //       width: double.infinity,
      //       height: MediaQuery.of(context).size.height - 75,
      //       decoration: ShapeDecoration(
      //         color: AppColors.secondaryText,
      //         shape: RoundedRectangleBorder(
      //           side: const BorderSide(width: 1, color: Color(0xFFE7E7E7)),
      //           borderRadius: const BorderRadius.only(
      //             topLeft: Radius.circular(50),
      //             topRight: Radius.circular(50),
      //           ),
      //         ),
      //       ),
      //       child: Padding(
      //         padding:
      //             const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Align(
      //               alignment: Alignment.topRight,
      //               child:
      //             ),
      //             SizedBox(height: 130),

      //             ProfileOptionTile(
      //               rightIcon: Icons.settings,
      //               text: 'Settings',
      //               onBackTap: () {},
      //             ),

      //             // for (var button in buttonData)
      //             //   Padding(
      //             //     padding: const EdgeInsets.only(bottom: 20),
      //             //     child: buildButton(
      //             //       button['text'],
      //             //       button['text'] == 'Log Out'
      //             //           ? AppColors.buttonColor
      //             //           : AppColors.secondaryText.withOpacity(0.9),
      //             //       button['text'] == 'Log Out'
      //             //           ? AppColors.secondaryText
      //             //           : Colors.black,
      //             //       onPressed: button['onPressed'],
      //             //     ),
      //             //   ),
      //           ],
      //         ),
      //       ),
      //     ),

      //     Positioned(
      //       top: 40,
      //       left: 30,
      //       right: 00,
      //       child: Row(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Container(
      //             width: 100,
      //             height: 100,
      //             child: _profileImage != null
      //                 ? CircleAvatar(
      //                     radius: 40,
      //                     backgroundImage: FileImage(_profileImage!),
      //                   )
      //                 : CircleAvatar(
      //                     radius: 40,
      //                     backgroundColor: AppColors.secondaryText,
      //                     child: Icon(
      //                       Icons.person,
      //                       color: Colors.white,
      //                       size: 50,
      //                     ),
      //                   ),
      //           ),
      //           const SizedBox(width: 15),
      //           Expanded(
      //             child: Text(
      //               username,
      //               style: const TextStyle(
      //                 fontSize: 20,
      //                 fontWeight: FontWeight.bold,
      //                 color: AppColors.primaryText,
      //                 fontFamily: 'Inter',
      //               ),
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
