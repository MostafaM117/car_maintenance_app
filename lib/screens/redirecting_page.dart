import 'package:car_maintenance/auth_page.dart';
import 'package:car_maintenance/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RedirectingPage extends StatelessWidget {
  const RedirectingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot){
          if(snapshot.hasData){
            return HomePage();
          }
          else{
            return AuthPage();
          }
        }),
    );
  }
}