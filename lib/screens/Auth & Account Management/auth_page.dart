import 'package:car_maintenance/screens/Auth%20&%20Account%20Management/signup_page.dart';
import 'package:car_maintenance/screens/Auth%20&%20Account%20Management/login_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void togglescreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showSignupPage: togglescreens);
    } else {
      return SignupPage(showLoginPage: togglescreens);
    }
  }
}
