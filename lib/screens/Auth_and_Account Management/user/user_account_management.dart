import 'dart:io';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/username_display.dart';
import 'package:car_maintenance/services/user_delete_account.dart';
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
  final _emailcontroller = TextEditingController();
  String? errorText;
  final user = FirebaseAuth.instance.currentUser!;

  //Update current username
  Future<void> _updateUsername() async {
    String newUsername = _usernameEditcontroller.text.trim();
    if (newUsername.isEmpty) {
      setState(() {
        errorText = "Username can't be empty.";
      });
      return;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'username': newUsername});
  }

  @override
  void initState() {
    super.initState();
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
                      // Username Below Profile Picture
                      UsernameDisplay(uid: user.uid),
                      Text(
                        '${user.email}',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                            child: UsernameDisplay(
                              uid: user.uid,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'Inter',
                              ),
                            )),
                      ],
                    ),
                    onTap: () async {
                      final userDoc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get();
                      final latestUsername = userDoc.data()?['username'] ?? '';
                      _usernameEditcontroller.text = latestUsername;
                      final result = await showDialog(
                          context: context,
                          builder: (context) =>
                              StatefulBuilder(builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFF4F4F4),
                                  title: Text(
                                    'Update your username below.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  content: SingleChildScrollView(
                                    child: SizedBox(
                                      height: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'This name will be used across your account and may be visible to others.',
                                            style: TextStyle(
                                              color: Colors.black
                                                  .withValues(alpha: 178),
                                              fontSize: 16,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextField(
                                            controller: _usernameEditcontroller,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              label: Text('Username'),
                                              labelStyle: TextStyle(
                                                  color: errorText != null
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .error
                                                      : Colors.black),
                                              errorText: errorText,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        side: BorderSide(
                                          color: Color(0xFFD9D9D9),
                                          width: 1,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        fixedSize: Size(250, 45),
                                      ),
                                      onPressed: () {
                                        final username =
                                            _usernameEditcontroller.text.trim();
                                        if (username.isEmpty) {
                                          setState(() {
                                            errorText =
                                                "username can't be empty.";
                                            return;
                                          });
                                        } else {
                                          Navigator.of(context).pop(username);
                                          _updateUsername();
                                        }
                                      },
                                      child: Text(
                                        'Save Changes',
                                        style: textStyleWhite.copyWith(
                                          fontSize: 18,
                                          color: AppColors.buttonColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryText,
                                        elevation: 0,
                                        side: BorderSide(
                                          color: Color(0xFFD9D9D9),
                                          width: 1,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        fixedSize: Size(250, 45),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        errorText = null;
                                      },
                                      child: Text(
                                        'Cansel',
                                        style: textStyleWhite.copyWith(
                                          fontSize: 18,
                                          color: AppColors.buttonText,
                                        ),
                                      ),
                                    ),
                                    // popUpBotton(
                                    //   'Update',
                                    //   Color(0xFFD9D9D9),
                                    //   AppColors.buttonColor,
                                    //   onPressed: () {
                                    //     final username =
                                    //         _usernameEditcontroller.text.trim();
                                    //     if (username.isEmpty) {
                                    //       setState(() {
                                    //         errorText =
                                    //             "username can't be empty.";
                                    //         return;
                                    //       });
                                    //     } else {
                                    //       Navigator.of(context).pop(username);
                                    //       _updateUsername();
                                    //     }
                                    //   },
                                    // ),
                                  ],
                                );
                              }));
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
                      // print('email pressed');
                    },
                  ),
                  GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                            child: Text('************',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'Inter',
                                ))),
                      ],
                    ),
                    onTap: () async {
                      final result = await showDialog(
                          context: context,
                          builder: (context) =>
                              StatefulBuilder(builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFF4F4F4),
                                  title: Text(
                                    'Change your Password',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  content: SingleChildScrollView(
                                    child: SizedBox(
                                      height: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: _emailcontroller,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              label: Text('email'),
                                              labelStyle: TextStyle(
                                                  color: errorText != null
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .error
                                                      : Colors.black),
                                              errorText: errorText,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    Column(
                                      children: [
                                        popUpBotton(
                                          'Send E-mail',
                                          AppColors.buttonColor,
                                          AppColors.buttonText,
                                          onPressed: () async {
                                            final email =
                                                _emailcontroller.text.trim();
                                            if (email.isEmpty) {
                                              setState(() {
                                                errorText =
                                                    "email can't be empty.";
                                                return;
                                              });
                                            } else {
                                              try {
                                                await FirebaseAuth.instance
                                                    .sendPasswordResetEmail(
                                                        email: email);
                                                _emailcontroller.clear();
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'A password reset email has been sent successfully.'),
                                                    backgroundColor:
                                                        Colors.green.shade400,
                                                    duration:
                                                        Duration(seconds: 3),
                                                  ),
                                                );
                                                errorText = null;
                                              } catch (e) {
                                                if (e.toString().contains(
                                                    'badly formatted')) {
                                                  setState(() {
                                                    errorText =
                                                        'Please enter a valid email address';
                                                    return;
                                                  });
                                                } else {
                                                  _emailcontroller.clear();
                                                  Navigator.of(context).pop();
                                                  errorText = null;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content:
                                                          Text(e.toString()),
                                                      backgroundColor:
                                                          Colors.red,
                                                      duration:
                                                          Duration(seconds: 3),
                                                    ),
                                                  );
                                                }
                                                print(e.toString());
                                              }
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        popUpBotton(
                                          'Cancel',
                                          AppColors.primaryText,
                                          AppColors.buttonText,
                                          onPressed: () {
                                            _emailcontroller.clear();
                                            Navigator.of(context).pop();
                                            errorText = null;
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }));
                      return result;
                    },
                  ),
                  SizedBox(
                    height: 40,
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
        ],
      ),
    );
  }
}
