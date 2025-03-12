import 'package:car_maintenance/screens/Auth/signup_page.dart';
import 'package:car_maintenance/screens/Auth/login_page.dart';
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
