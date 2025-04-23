import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/seller_login_page.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/seller_signup_page.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/user/user_signup_page.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/user/user_login_page.dart';
import 'package:flutter/material.dart';

class SellerAuthPage extends StatefulWidget {
  const SellerAuthPage({super.key});

  @override
  State<SellerAuthPage> createState() => _SellerAuthPageState();
}

class _SellerAuthPageState extends State<SellerAuthPage> {
  bool showLoginPage = true;

  void togglescreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SellerLoginPage(showSellerSignupPage: togglescreens);
    } else {
      return SellerSignupPage(showSellerLoginPage: togglescreens);
    }
  }
}
