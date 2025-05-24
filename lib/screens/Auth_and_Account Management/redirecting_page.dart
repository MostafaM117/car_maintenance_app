import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/store_not_verified.dart';
import 'package:car_maintenance/screens/Current_Screen/seller_main_screen.dart';
import 'package:car_maintenance/screens/Current_Screen/user_main_screen.dart';
// import 'package:car_maintenance/screens/before_login/login_type.dart';
import 'package:car_maintenance/screens/before_login/welcome_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../formscreens/formscreen1.dart';

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
              // print("AuthWrapper: No user signed in, navigating to WelcomePage...");
              return const WelcomePage();
            }
            else{
            final user = snapshot.data!;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.uid).get(), 
              builder: (context, userSnaphot){
                if(userSnaphot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                else if(userSnaphot.hasData && userSnaphot.data!.exists){
                  final userData = userSnaphot.data!.data() as Map<String, dynamic>; 
                  if(userData["carAdded"] == false){
                    print('You haven\'t added your first car yet.');
                    return AddCarScreen();
                  }
                  else{
                    return UserMainScreen();
                  }
                }
                else{
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('sellers').doc(user.uid).get(), 
                    builder: (context,sellersnapshot){
                      if(sellersnapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(body: Center(child: CircularProgressIndicator()));
                      }
                      else if(sellersnapshot.hasData && sellersnapshot.data!.exists){
                        final sellerData = sellersnapshot.data!.data() as Map<String, dynamic>; 
                          if(sellerData['store_verified'] == false){
                            return StoreNotVerified();
                          }
                          else{
                            return SellerMainScreen();
                          }
                      }
                      else{
                        print('returned here');
                        return WelcomePage();
                      }
                    });
                }
              });
            }
          }),
    );
  }
}