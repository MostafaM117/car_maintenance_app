import 'package:car_maintenance/constants/app_colors.dart';
// import 'package:car_maintenance/main.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/businessname_display.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/seller_account_management.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/auth_service.dart';
import 'package:car_maintenance/screens/Terms_and_conditionspage%20.dart';
// import 'package:car_maintenance/services/seller/seller_data_helper.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n.dart';
import '../../widgets/language_toggle_widget.dart';
import '../../widgets/profile_option_tile.dart.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({super.key, this.onChangeLanguage});
  final Function(Locale)? onChangeLanguage;

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
                SizedBox(
                  height: 25,
                ),
                Text(
                  S.of(context).account,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: 'Inter',
                    height: 0,
                    // letterSpacing: 9.20,
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
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
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
                      if (rawData == null) {
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
                    const SizedBox(height: 30),
                    ProfileOptionTile(
                      text: S.of(context).profile,
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
                    LanguageToggle(),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    buildButton(
                      S.of(context).logout,
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
