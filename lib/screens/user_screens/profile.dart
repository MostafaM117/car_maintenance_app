import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/user_screens/MyCars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../services/user_data_helper.dart';
import '../../widgets/custom_widgets.dart';
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
                const SizedBox(height: 25),

                Text(
                  S.of(context).account,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: 'Inter',
                    height: 0,
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
                      if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(
                            radius: 65,
                            backgroundColor: AppColors.lightGray,
                            child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        print('Something went wrong, Error: ${snapshot.error}');
                        return Center(child: Text('Something went wrong'));
                      }
                      if (!snapshot.data!.exists) {
                        print('Document does not exist');
                        return Center(child: Text('Document does not exist'));
                      }
                      final rawData = snapshot.data!.data();
                      if(rawData == null ){
                        print('Data is null');
                        return Center(child: Text('No data found'));
                      }
                      final data = rawData as Map<String, dynamic>;
                      final imageUrl = data['imageUrl'] as String?;

                      if (imageUrl == null || imageUrl.isEmpty) {
                        return CircleAvatar(
                          radius: 65,
                          backgroundColor: AppColors.lightGray,
                          child:
                              Icon(Icons.person, size: 65, color: Colors.grey),
                        );
                      }

                      return CircleAvatar(
                        radius: 65,
                        backgroundColor: AppColors.lightGray,
                        child: ClipOval(
                          child: SizedBox(
                            width: 126,
                            height: 126,
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
                      text: S.of(context).profile,
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
                      text: S.of(context).my_cars,
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
                   LanguageToggle(),
                    SizedBox(
                      height: 20,
                    ),
                    ProfileOptionTile(
                      text: S.of(context).terms_conditions,
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
                      S.of(context).logout,
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
