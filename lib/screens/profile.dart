import 'dart:io';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/MyCars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_data_helper.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/profile_option_tile.dart.dart';
import 'Auth_and_Account Management/user/user_account_management.dart';
import 'Auth_and_Account Management/auth_service.dart';
import 'Terms_and_conditionspage .dart';

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
    if (!mounted) return;
    setState(() {
      username = fetchedUsername ?? 'User';
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
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(), 
                  builder: (context, snapshot){
                    if(snapshot.hasData && snapshot.data!.exists){
                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      final username = data['username']?? '';
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
                    }
                    else{
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
                      text: 'Profile',
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
                    ProfileOptionTile(
                      text: 'Settings',
                      onBackTap: () {},
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ProfileOptionTile(
                      text: 'Activity',
                      onBackTap: () {},
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
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // ProfileOptionTile(
                    //   rightIcon: Icons.help_outline,
                    //   text: 'Help & Support',
                    //   onBackTap: () {},
                    // ),
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
