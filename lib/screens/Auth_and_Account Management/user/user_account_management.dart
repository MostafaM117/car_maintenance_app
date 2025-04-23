import 'dart:io';

import 'package:car_maintenance/services/delete_account.dart';
import 'package:car_maintenance/services/forgot_password.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/BackgroundDecoration.dart';
import '../../../widgets/profile_image.dart';

class UserAccountManagement extends StatefulWidget {
  const UserAccountManagement({super.key});

  @override
  State<UserAccountManagement> createState() => _UserAccountManagementState();
}

class _UserAccountManagementState extends State<UserAccountManagement> {
  final _usernameEditcontroller = TextEditingController();
  bool _isediting = false;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username cannot be empty'),
          backgroundColor: Colors.red,
        ),
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
          const CurvedBackgroundDecoration(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Account",
                    style: textStyleWhite.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 9.20,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      ProfileImagePicker(
                        onImagePicked: (File image) {
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              _usernameEditcontroller.text,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                                fontFamily: 'Inter',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${user.email}',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 10,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // buildTextUserNameField(
                  buildUserNameField(
                    controller: _usernameEditcontroller,
                    isEditing: _isediting,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username cannot be empty';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isediting
                              ? AppColors.buttonColor
                              : AppColors.secondaryText,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                _isediting
                                    ? "Update username"
                                    : "Edit username",
                                style: _isediting
                                    ? textStyleWhite.copyWith(
                                        color: AppColors.secondaryText)
                                    : textStyleWhite.copyWith(
                                        color: Colors.black)),
                          ],
                        ),
                        onPressed: () {
                          if (_usernameEditcontroller.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Username can\'t be empty'),
                                backgroundColor:
                                    const Color.fromARGB(141, 244, 67, 54),
                              ),
                            );
                          } else {
                            _toggleEdit();
                            _updateUsername();
                            _isediting
                                ? ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Now you can edit your username'),
                                      duration: Duration(milliseconds: 1000),
                                    ),
                                  )
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Username updated successfully'),
                                      duration: Duration(milliseconds: 1000),
                                      backgroundColor: const Color.fromARGB(
                                          158, 102, 187, 106),
                                    ),
                                  );
                          }
                        }),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  buildButton(
                    'Edit Password',
                    AppColors.secondaryText,
                    Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
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
                              style: TextStyle(fontWeight: FontWeight.w600,fontSize: 24,),
                            ),
                            content: const Text(
                                'This action is permanent and cannot be undone. All your data will be permanently removed..',
                                textAlign: TextAlign.center),
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
                                  DeleteAccount().deleteAccount(context);
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
