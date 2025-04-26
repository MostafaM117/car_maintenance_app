import 'dart:io';

import 'package:car_maintenance/services/user_delete_account.dart';
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
      body: Scaffold(
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        Text(
                          "Profile",
                          style: textStyleWhite.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 9.20,
                          ),
                        ),
                        SizedBox(height: 30),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 393,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.only(
                                  left: 100, top: 20, bottom: 20, right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                            Positioned(
                              top: 15,
                              child: ProfileImagePicker(
                                onImagePicked: (File image) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
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
                                if (_usernameEditcontroller.text
                                    .trim()
                                    .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Username can\'t be empty'),
                                      backgroundColor: const Color.fromARGB(
                                          141, 244, 67, 54),
                                    ),
                                  );
                                } else {
                                  _toggleEdit();
                                  _updateUsername();
                                  _isediting
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Now you can edit your username'),
                                            duration:
                                                Duration(milliseconds: 1000),
                                          ),
                                        )
                                      : ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Username updated successfully'),
                                            duration:
                                                Duration(milliseconds: 1000),
                                            backgroundColor:
                                                const Color.fromARGB(
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
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
                                        UserDeleteAccount()
                                            .userdeleteAccount(context);
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
              )
            ],
          )),
    );
  }
}
