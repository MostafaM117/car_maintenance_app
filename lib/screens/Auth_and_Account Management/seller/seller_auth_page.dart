import 'package:flutter/material.dart';
import 'seller_login_page.dart';
import 'seller_signup_page.dart';

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
