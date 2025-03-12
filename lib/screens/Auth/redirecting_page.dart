import 'package:car_maintenance/screens/Auth/auth_page.dart';
import 'package:car_maintenance/screens/Auth/check_auth_status.dart';
import 'package:car_maintenance/screens/Current_Screen/main_screen.dart';
import 'package:car_maintenance/screens/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RedirectingPage extends StatelessWidget {
  const RedirectingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MainScreen();
            } else {
              return WelcomePage();
            }
          }),
    );
  }
}
