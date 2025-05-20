import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../services/seller/seller_data_helper.dart';
import '../../widgets/SubtractWave_widget.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({super.key});

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  String username = 'Loading...';
  final seller = FirebaseAuth.instance.currentUser!;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('sellers');
  @override
  void initState() {
    super.initState();
    loadSellername();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 11,
            left: 11,
            top: 20,
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              SubtractWave(
                text: 'Welcome Back, ${username.split(' ').first}',
                svgAssetPath: 'assets/svg/notification.svg',
                onTap: () {},
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Requests',
                    style: TextStyle(
                      color: const Color(0xFF0F0F0F),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7),
              // Add Requests cards
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRequestsCard(),
                  SizedBox(height: 7),
                  _buildRequestsCard(),
                ],
              ),
              SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Explore',
                    style: TextStyle(
                      color: const Color(0xFF0F0F0F),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildExploreCard(),
                  _buildExploreCard(),
                  _buildExploreCard(),
                ],
              ),
              SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Best Selling',
                    style: TextStyle(
                      color: const Color(0xFF0F0F0F),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSellingCard(),
                  _buildSellingCard(),
                  _buildSellingCard(),
                ],
              ),
              SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Low Stock',
                    style: TextStyle(
                      color: const Color(0xFF0F0F0F),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSellingCard(),
                  _buildSellingCard(),
                  _buildSellingCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildRequestsCard(
    // BuildContext context, String title, IconData icon, Color color, VoidCallback onTap
    ) {
  return GestureDetector(
    // onTap: ,
    child: Container(
      width: double.infinity,
      height: 55,
      decoration: ShapeDecoration(
        color: AppColors.secondaryText,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.borderSide,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
          // SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Widget _buildExploreCard(
    // BuildContext context, String title, IconData icon, Color color, VoidCallback onTap
    ) {
  return GestureDetector(
    // onTap: ,
    child: Container(
      width: 100,
      height: 45,
      decoration: ShapeDecoration(
        color: AppColors.secondaryText,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.borderSide,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Widget _buildSellingCard(
    // BuildContext context, String title, IconData icon, Color color, VoidCallback onTap
    ) {
  return GestureDetector(
    // onTap: ,
    child: Container(
      width: 100,
      height: 125,
      decoration: ShapeDecoration(
        color: AppColors.secondaryText,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.borderSide,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    ),
  );
}
