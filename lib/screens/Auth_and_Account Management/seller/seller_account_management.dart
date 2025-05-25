import 'dart:io';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/businessname_display.dart';
import 'package:car_maintenance/services/seller/seller_delete_account.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/info_field.dart';
// import '../../../widgets/profile_image.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SellerAccountManagement extends StatefulWidget {
  const SellerAccountManagement({super.key});

  @override
  State<SellerAccountManagement> createState() =>
      _SellerAccountManagementState();
}

class _SellerAccountManagementState extends State<SellerAccountManagement> {
  final _businessnameEditcontroller = TextEditingController();
  final _businessemailcontroller = TextEditingController();
  String? errorText;
  final seller = FirebaseAuth.instance.currentUser!;
  String? imageUrl;
  bool _isImageLoading = true;

  //Update current username
  Future<void> _updateBusinessname() async {
    String newBusinessname = _businessnameEditcontroller.text.trim();
    if (newBusinessname.isEmpty) {
      setState(() {
        errorText = "Username can't be empty.";
      });
      return;
    }
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(seller.uid)
        .update({'business_name': newBusinessname});
  }

  //Upload Profile Images to Supabase
  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    final file = File(pickedFile.path);
    final fileName = '${seller.uid}_${path.basename(pickedFile.path)}';
    final storage = Supabase.instance.client.storage;
    const bucket = 'shop-images';
    try {
      final existingFiles = await storage.from(bucket).list();
      final fileExists = existingFiles.any((file) => file.name == fileName);
      String? publicUrl;
      if (fileExists) {
        publicUrl = storage.from(bucket).getPublicUrl(fileName);
        print('File already exists: $fileName, reusing URL.');
      } else {
        await storage.from(bucket).upload(fileName, file);
        publicUrl = storage.from(bucket).getPublicUrl(fileName);
        print('Image uploaded successfully: $publicUrl');
      }
      await FirebaseFirestore.instance.collection('sellers').doc(seller.uid).set({
        'shop_imageUrl': publicUrl,
      }, SetOptions(merge: true));
      await loadImage();
    } catch (e) {
      print('Upload error: $e');
    }
  }

  //loadImage
  Future<void> loadImage() async {
    final doc = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(seller.uid)
        .get();
    setState(() {
      imageUrl = doc.data()?['shop_imageUrl'];
      _isImageLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadImage();
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
                      SizedBox(height: 20),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.lightGray,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 120,
                                height: 120,
                                child: _isImageLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : imageUrl != null && imageUrl!.isNotEmpty
                                        ? Image.network(
                                            imageUrl!,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null){
                                                return child;
                                              }
                                              return const Center(
                                                  child: CircularProgressIndicator());
                                            },
                                          )
                                        : Icon(Icons.person, size: 60),
                                        // Image.asset('assets/default_profile.png'),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  _isImageLoading = true;
                                });
                                await pickAndUploadImage();
                                await loadImage();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(Icons.edit,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      BusinessnameDisplay(
                        uid: seller.uid,
                      ),
                      Text(
                        '${seller.email}',
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
                            'Business name',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
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
                            child: BusinessnameDisplay(
                              uid: seller.uid,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'Inter',
                              ),
                            )),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Update Business Name'),
                          content: TextField(
                            controller: _businessnameEditcontroller,
                            decoration: InputDecoration(
                              labelText: 'Business Name',
                              errorText: errorText,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                errorText = null;
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final businessname =
                                    _businessnameEditcontroller.text.trim();
                                if (businessname.isEmpty) {
                                  setState(() {
                                    errorText = "Businessname can't be empty.";
                                  });
                                } else {
                                  await _updateBusinessname();
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InfoField(
                    label: 'Email',
                    value: '${seller.email}',
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
                        const SizedBox(height: 8),
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
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Change Password'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Please enter your email to receive a password reset link.'),
                              SizedBox(height: 20),
                              TextField(
                                controller: _businessemailcontroller,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  errorText: errorText,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                errorText = null;
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                final email =
                                    _businessemailcontroller.text.trim();
                                if (email.isEmpty) {
                                  setState(() {
                                    errorText = "email can't be empty.";
                                  });
                                } else {
                                  try {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(email: email);
                                    _businessemailcontroller.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'A password reset email has been sent successfully.'),
                                        backgroundColor: Colors.green.shade400,
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    errorText = null;
                                    Navigator.pop(context);
                                  } catch (e) {
                                    if (e
                                        .toString()
                                        .contains('badly formatted')) {
                                      setState(() {
                                        errorText =
                                            'Please enter a valid email address';
                                      });
                                    } else {
                                      _businessemailcontroller.clear();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString()),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                    print(e.toString());
                                  }
                                }
                              },
                              child: Text('Send Reset Link'),
                            ),
                          ],
                        ),
                      );
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
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            content: SizedBox(
                              height: 100,
                              child: Center(
                                child: const Text(
                                  'This action cannot be undone.All of your data will be permanently deleted.',
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
                                  SellerDeleteAccount()
                                    .sellerdeleteAccount(context);
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
