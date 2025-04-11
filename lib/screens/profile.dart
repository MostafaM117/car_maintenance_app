import 'dart:io';

import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/MyCars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_data_helper.dart';
import '../widgets/custom_widgets.dart';
import 'Auth_and_Account Management/account_management.dart';
import 'Auth_and_Account Management/auth_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = 'Loading...';
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    loadUsername();
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
  void loadUsername() async {
    String? fetchedUsername = await getUsername();
    setState(() {
      username = fetchedUsername ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Create button data inside the build method
    final List<Map<String, dynamic>> buttonData = [
      {
        'text': 'Manage your account',
        'onPressed': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountManagement()),
            ),
      },
      {
        'text': 'My Cars',
        'onPressed': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CarMaint()),
            ),
      },
      {'text': 'User Guide', 'onPressed': () => ()},
      {
        'text': 'Log Out',
        'onPressed': () {
          AuthService().signOut(context);
        },
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Main container
            Container(
              margin: const EdgeInsets.only(top: 100),
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 75,
              decoration: ShapeDecoration(
                color: AppColors.secondaryText,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFE7E7E7)),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        '${user.email}',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 130),
                    for (var button in buttonData)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: buildButton(
                          button['text'],
                          button['text'] == 'Log Out'
                              ? AppColors.buttonColor
                              : AppColors.secondaryText.withOpacity(0.9),
                          button['text'] == 'Log Out'
                              ? AppColors.secondaryText
                              : Colors.black,
                          onPressed: button['onPressed'],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 40,
              left:30,
              right: 00,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
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
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                        fontFamily: 'Inter',
                      ),
                      overflow: TextOverflow.ellipsis,
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
