import 'package:car_maintenance/screens/Auth_and_Account%20Management/user/user_signup_page.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/user/user_login_page.dart';
import 'package:flutter/material.dart';

class UserAuthPage extends StatefulWidget {
  const UserAuthPage({super.key});

  @override
  State<UserAuthPage> createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {
  bool showLoginPage = true;

  void togglescreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return UserLoginPage(showUserSignupPage: togglescreens);
    } else {
      return UserSignupPage(showUserLoginPage: togglescreens);
    }
  }
}
