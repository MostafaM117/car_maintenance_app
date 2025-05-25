import 'dart:io';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/user_screens/MyCars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/user_data_helper.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/darkmode_toggle_widget.dart';
import '../../widgets/language_toggle_widget.dart';
import '../../widgets/profile_option_tile.dart.dart';
import '../Auth_and_Account Management/user/user_account_management.dart';
import '../Auth_and_Account Management/auth_service.dart';
import '../Terms_and_conditionspage .dart';

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
  bool isEnglish = true;
  bool isDarkMode = false;

  void loadUsername() async {
    String? fetchedUsername = await getUsername();
    if (!mounted) return;
    setState(() {
      username = fetchedUsername ?? 'User';
    });
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
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
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircleAvatar(
                            radius: 60,
                            backgroundColor: AppColors.lightGray,
                            child: CircularProgressIndicator());
                      }
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final imageUrl = data['imageUrl'] as String?;

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
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final username = data['username'] ?? '';
                        return Text(
                          username,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Inter',
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      } else {
                        return Text('loading...');
                      }
                    }),
                Text(
                  '${user.email}',
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
                      text: 'Account Management',
                      onBackTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserAccountManagement()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ProfileOptionTile(
                      text: 'MyCars',
                      onBackTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CarMaint()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                    SizedBox(
                      height: 20,
                    ),
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
                    SizedBox(
                      height: 20,
                    ),
                    buildButton(
                      'Log Out',
                      AppColors.buttonColor,
                      AppColors.buttonText,
                      onPressed: () {
                        AuthService().signOut(context);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
