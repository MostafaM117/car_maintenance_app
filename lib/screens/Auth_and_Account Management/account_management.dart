import 'dart:io';

import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/services/delete_account.dart';
import 'package:car_maintenance/services/forgot_password.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/profile_image.dart';
import '../../widgets/BackgroundDecoration.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({super.key});

  @override
  State<AccountManagement> createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  final TextEditingController _usernameEditcontroller = TextEditingController();
  bool _isediting = false;
  final User? _user = FirebaseAuth.instance.currentUser;
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> _getcurrentusername() async {
    if (_user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          _usernameEditcontroller.text = userDoc['username'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUsername() async {
    if (_user == null) return;

    String newUsername = _usernameEditcontroller.text.trim();
    if (newUsername.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username can\'t be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .update({'username': newUsername});
  }

  void _toggleEdit() {
    setState(() {
      _isediting = !_isediting;
      if (_isediting) {
        _getcurrentusername();
        _usernameEditcontroller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _usernameEditcontroller.text.length,
        );
      } else {
        _updateUsername();
      }
    });

    if (!_isediting) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username updated successfully'),
          backgroundColor: Colors.green.shade400,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Now you can edit your username'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getcurrentusername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          setState(() {
                          });
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
                  const SizedBox(height: 30),
                  buildTextField(
                    controller: _usernameEditcontroller,
                    label: null,
                    validator: (value) => null,
                    suffixIcon: IconButton(
                      onPressed: _toggleEdit,
                      icon: SvgPicture.asset(
                        _isediting
                            ? 'assets/svg/check.svg'
                            : 'assets/svg/edit.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    isEnabled: _isediting,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  buildButton(
                    'Edit Password',
                    AppColors.buttonText,
                    AppColors.buttonColor,
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
                            title: const Text('Delete Account'),
                            content: const Text(
                              'Are you sure you want to delete your account? \nThis action will delete the account totally and will remove all related data.',
                            ),
                            actions: [
                              buildButton(
                                'Delete',
                                AppColors.buttonColor,
                                AppColors.buttonText,
                                onPressed: () {
                                  DeleteAccount().deleteAccount(context);
                                },
                              ),SizedBox(height: 15,),
                              buildButton(
                                'Discard',
                                AppColors.buttonText,
                                AppColors.buttonColor,
                                onPressed: () {
                                  Navigator.pop(context);
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
