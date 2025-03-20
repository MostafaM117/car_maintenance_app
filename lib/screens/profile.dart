import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/account_management.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/auth_service.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(
              'Manage Your Account', Colors.red.shade700, Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountManagement()));
              }
            ),
            SizedBox(
              height: 30,
            ),
            buildButton(
              'Sign Out', Colors.red.shade700, Colors.white,
              onPressed: () {
                AuthService().signOut(context);
              }
            ),
          ],
        ),
      ),
    );
  }
}
