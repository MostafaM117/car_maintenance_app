import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/formscreens/formscreen1.dart';

class CompleteSigninData extends StatefulWidget {
  const CompleteSigninData({super.key});

  @override
  State<CompleteSigninData> createState() => _CompleteSigninDataState();
}

class _CompleteSigninDataState extends State<CompleteSigninData> {
  final _usernameController = TextEditingController();
  bool _isCheckingUsername = false;
  // bool _isUsernameAvailable = true;
  String _usernameErrorText = '';

  // Future<bool> CheckUserName(String username) async {
  //   setState(() {
  //     _isCheckingUsername = true;
  //     _isUsernameAvailable = true;
  //     _usernameErrorText = '';
  //   });
    
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('username', isEqualTo: username)
  //         .get();
      
  //     setState(() {
  //       _isCheckingUsername = false;
  //       _isUsernameAvailable = querySnapshot.docs.isEmpty;
  //       if (!_isUsernameAvailable) {
  //         _usernameErrorText = 'Username is already taken';
  //       }
  //     });
      
  //     return querySnapshot.docs.isEmpty;
  //   } catch (e) {
  //     setState(() {
  //       _isCheckingUsername = false;
  //       _usernameErrorText = 'Error checking username';
  //     });
  //     return false;
  //   }
  // }
  Future<void> _saveUserName() async{
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a username to continue')),
      );
      return;
    }
    
    // final isUnique = await CheckUserName(_usernameController.text.trim());
    // if (!isUnique) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Username is already taken, try another one')),
    //   );
    //   return;
    // }
    // Save the username to Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    String username = _usernameController.text.trim();
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      "email": user.email,
      "username": username,
      "uid": user.uid,
      "carAdded": false,
    });
    // Navigate to the AddCarPage to add his first car
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddCarScreen()));

  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set a username', style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Welcome To Motorgy App, Please enter your username"),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                errorText: _usernameErrorText.isNotEmpty ? _usernameErrorText : null,
                suffixIcon: _isCheckingUsername 
                      ? Container(
                          width: 20,
                          height: 20,
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ) 
                      : null,
              ),
            ),
            ElevatedButton(
              onPressed: _saveUserName,
              child: Text("Continue"),
              style: ElevatedButton.styleFrom(),
            ),
          ],
        ),
        )
    );
  }
}