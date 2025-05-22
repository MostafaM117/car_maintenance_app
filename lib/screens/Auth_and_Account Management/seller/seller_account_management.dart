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
import '../../../widgets/profile_image.dart';

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
  final user = FirebaseAuth.instance.currentUser!;
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
      }
      else{
        await storage.from(bucket).upload(fileName, file);
        publicUrl = storage.from(bucket).getPublicUrl(fileName);
        print('Image uploaded successfully: $publicUrl');
      }
      await FirebaseFirestore.instance.collection('seller').doc(user.uid).set({
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
        .collection('seller')
        .doc(user.uid)
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
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 130,
                              height: 130,
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
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 60,
                                        ),
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
                      // ProfileImagePicker(
                      //   onImagePicked: (File image) {
                      //     setState(() {});
                      //   },
                      // ),
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
                    onTap: () async {
                      final userDoc = await FirebaseFirestore.instance
                          .collection('sellers')
                          .doc(seller.uid)
                          .get();
                      final latestUsername =
                          userDoc.data()?['business_name'] ?? '';
                      _businessnameEditcontroller.text = latestUsername;
                      final result = await showDialog(
                          context: context,
                          builder: (context) =>
                              StatefulBuilder(builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFF4F4F4),
                                  title: Text(
                                    'Update your \nbusiness name below',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            'This name will be used across your account and may be visible to others.'),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          controller:
                                              _businessnameEditcontroller,
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                            label: Text('Business name'),
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
                                  actionsAlignment: MainAxisAlignment.center,
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
                                        final businessname =
                                            _businessnameEditcontroller.text
                                                .trim();
                                        if (businessname.isEmpty) {
                                          setState(() {
                                            errorText =
                                                "Businessname can't be empty.";
                                            return;
                                          });
                                        } else {
                                          Navigator.of(context)
                                              .pop(businessname);
                                          _updateBusinessname();
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
                                        'Cancel',
                                        style: textStyleWhite.copyWith(
                                          fontSize: 18,
                                          color: AppColors.buttonText,
                                        ),
                                      ),
                                    ),
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
                    onTap: () async {
                      final result = await showDialog(
                          context: context,
                          builder: (context) =>
                              StatefulBuilder(builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFFF4F4F4),
                                  title: Text(
                                    'Change your Password',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            'Please verify that this is your email. You will receive an email with a link to change your password.'),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextField(
                                          controller:
                                              _businessemailcontroller,
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
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    Column(
                                      children: [
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
                                          child: Text(
                                            'Send E-mail',
                                            style: textStyleWhite.copyWith(
                                              fontSize: 18,
                                              color: AppColors.buttonColor,
                                            ),
                                          ),
                                          onPressed: () async {
                                            final email =
                                                _businessemailcontroller.text
                                                    .trim();
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
                                                _businessemailcontroller
                                                    .clear();
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
                                                  _businessemailcontroller
                                                      .clear();
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
                                          height: 15,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryText,
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
                                            _businessemailcontroller.clear();
                                            Navigator.of(context).pop();
                                            errorText = null;
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: textStyleWhite.copyWith(
                                              fontSize: 18,
                                              color: AppColors.buttonText,
                                            ),
                                          ),
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
