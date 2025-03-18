import 'package:car_maintenance/forms/carform.dart';
import 'package:car_maintenance/forms/complete_signin_data.dart';
import 'package:car_maintenance/screens/Current_Screen/main_screen.dart';
import 'package:car_maintenance/screens/welcome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if(!snapshot.hasData || snapshot.data == null) {
              print("AuthWrapper: No user signed in, navigating to WelcomePage...");
              return const WelcomePage();
            }
            final user = snapshot.data!;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(), 
              builder: (context, userSnaphot){
                if(userSnaphot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (!userSnaphot.hasData || !userSnaphot.data!.exists){
                  FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                    'username': null,
                    'email': user.email,
                    'carAdded': false,
                  });
                  return CompleteSigninData();
                  
                }
                final userData = userSnaphot.data!.data() as Map<String, dynamic>; 
                if(userData["username"] == null){
                  return CompleteSigninData();
                }
                if(userData["carAdded"] == false){
                  return AddCarScreen();
                }
                return MainScreen();
              });
          }),
    );
  }
}
