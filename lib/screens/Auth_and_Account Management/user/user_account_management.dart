import 'dart:io';

import 'package:car_maintenance/services/user_delete_account.dart';
import 'package:car_maintenance/services/forgot_password.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/info_field.dart';
import '../../../widgets/profile_image.dart';

class UserAccountManagement extends StatefulWidget {
  const UserAccountManagement({super.key});

  @override
  State<UserAccountManagement> createState() => _UserAccountManagementState();
}

class _UserAccountManagementState extends State<UserAccountManagement> {
  final _usernameEditcontroller = TextEditingController();
  bool _isediting = false;
  String? errorText;
  User? _user = FirebaseAuth.instance.currentUser;
  final user = FirebaseAuth.instance.currentUser!;
  //Get current username
  Future<void> _getcurrentusername() async {
    if (_user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _usernameEditcontroller.text = userDoc['username'] ?? '';
        });
      }
    }
  }

  //Update current username
  Future<void> _updateUsername() async {
    if (_user == null) {
      return;
    }
    String newUsername = _usernameEditcontroller.text.trim();
    if (newUsername.isEmpty) {
      setState(() {
        errorText = "username can't be empty.";
        return;
        }
      );
      return;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .update({'username': newUsername});
  }

  // Press edit username to edit
  void _toggleEdit() {
    setState(() {
      _isediting = !_isediting;
    });
  }

  @override
  void initState() {
    super.initState();
    _getcurrentusername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 60,
                  // ),
                  Text(
                    "Account",
                    style: textStyleWhite.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 9.20,
                    ),
                  ),

                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ProfileImagePicker(
                        onImagePicked: (File image) {
                          setState(() {});
                        },
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(), 
                        builder: (context, snapshot){
                          if(snapshot.hasData && snapshot.data!.exists){
                            final data = snapshot.data!.data() as Map<String, dynamic>;
                            final username = data['username']?? '';
                            return Text(
                              username,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                                fontFamily: 'Inter',
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          else{
                            return Text('loading...');
                          }
                        }),
                        SizedBox(
                          height: 20,
                        )
                      // Text(
                      //   '${user.email}',
                      //   style: TextStyle(
                      //     color: Colors.black.withOpacity(0.7),
                      //     fontSize: 10,
                      //     fontFamily: 'Inter',
                      //   ),
                      // ),
                    ],
                  ),
                  // Username from Database
                  GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 45,                    
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          decoration: ShapeDecoration(
                            color: Color(0xFFF4F4F4),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                              width: 1,
                              color: AppColors.borderSide,
                              ),
                          borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(), 
                              builder: (context, snapshot){
                                if(snapshot.hasData && snapshot.data!.exists){
                                  final data = snapshot.data!.data() as Map<String, dynamic>;
                                  final username = data['username']?? '';
                                  return Text(
                                    username,
                                    style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'Inter',
                                    ),
                                  );
                                  }
                                  else{
                                    return Text('loading...');
                                  }
                                }),
                        ),
                      ],
                    ),
                    onTap: () async{
                      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                      final latestUsername = userDoc.data()?['username']?? '';
                      _usernameEditcontroller.text = latestUsername;
                      final result = await showDialog(context: context, builder: (context) => 
                      StatefulBuilder(builder: (context, setState){
                        return AlertDialog(
                          backgroundColor: Color(0xFFF4F4F4),
                            title: 
                              Text('Edit your username and click update',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                                ),
                              ),
                            content: SingleChildScrollView(
                              child: SizedBox(
                                height: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _usernameEditcontroller,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        label: Text('Username'),
                                        labelStyle: TextStyle(color: errorText != null? Theme.of(context).colorScheme.error : Colors.black),
                                        errorText: errorText,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              popUpBotton(
                                'Update',
                              AppColors.buttonColor,
                              AppColors.buttonText,
                                onPressed: () {
                                  final username = _usernameEditcontroller.text.trim();
                                  if (username.isEmpty) {
                                    setState(() {
                                      errorText = "username can't be empty.";
                                      return;
                                    });
                                  } else {
                                    Navigator.of(context).pop(username);
                                    _updateUsername();
                                  }
                                },
                              ),
                              popUpBotton(
                                'Cancel',
                              AppColors.primaryText,
                              AppColors.buttonText,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  errorText = null;
                                },
                              ),
                            ],
                          );
                      }
                      ));
                        return result;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InfoField(
                    label: 'Email',
                    value: '${user.email}',
                    onTap: () {
                      print('email pressed');
                    },
                  ),
                  InfoField(
                    label: 'Password',
                    value: '********',
                    onTap: () {
                      // Password Popup will be here
                      print('Name pressed');
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // buildButton(
                  //   'Edit Password',
                  //   AppColors.secondaryText,
                  //   Colors.black,
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => ForgotPassword()),
                  //     );
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  buildButton(
                    'Delete Account',
                    AppColors.buttonColor,
                    AppColors.buttonText,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: AppColors.secondaryText,
                            title: const Text(
                              'Are you sure you want to delete your account?',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,),
                            ),
                            content: SizedBox(
                              height: 100,
                              child: Center(
                                child: const Text(
                                    'This action cannot be undone.\nAll of your data will be permanently deleted.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                    ),
                              ),
                            ),
                            actions: [
                              popUpBotton(
                                'Cancel',
                                AppColors.primaryText,
                                AppColors.buttonText,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              popUpBotton(
                                'Delete',
                                AppColors.buttonColor,
                                AppColors.buttonText,
                                onPressed: () {
                                  UserDeleteAccount().userdeleteAccount(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
