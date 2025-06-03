import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/username_display.dart';
import 'package:car_maintenance/services/user_delete_account.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../constants/app_colors.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/info_field.dart';

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
  String? imageUrl;
  bool _isImageLoading = true;

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

  //Upload Profile Images to Supabase
  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    final file = File(pickedFile.path);
    final fileName = '${user.uid}_${path.basename(pickedFile.path)}';
    final storage = Supabase.instance.client.storage;
    const bucket = 'user-profile-images';
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
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'imageUrl': publicUrl,
      }, SetOptions(merge: true));
      await loadImage();
    } catch (e) {
      print('Upload error: $e');
    }
  }

  //load Image
  Future<void> loadImage() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      imageUrl = doc.data()?['imageUrl'];
      _isImageLoading = false;
    });
  }

  //Delete Image
  Future<void> deleteProfileImage() async {
    const bucket = 'user-profile-images';
    try {
      if (imageUrl == null || imageUrl!.isEmpty) {
        return;
      } else {
        final uri = Uri.parse(imageUrl!);
        final segments = uri.pathSegments;
        final bucketIndex = segments.indexOf(bucket);
        if (bucketIndex == -1 || bucketIndex + 1 >= segments.length) {
          throw Exception("Could not extract file name from imageUrl.");
        }
        final filename = segments[bucketIndex + 1];
        await Supabase.instance.client.storage.from(bucket).remove([filename]);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'imageUrl': FieldValue.delete(),
        });
        setState(() {
          imageUrl == null;
          _isImageLoading = false;
        });
        print('Image deleted successfully.');
      }
    } catch (e) {
      print('Error While deleting profile image $e');
    }
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
                  Text(
                    S.of(context).profile,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Inter',
                      height: 0,
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.lightGray,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 116,
                                height: 116,
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
                                              if (loadingProgress == null) {
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
                                // Image.asset('assets/default_profile.png'),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                showModalBottomSheet(
                                    backgroundColor: AppColors.background,
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: Icon(
                                              Icons.upload_outlined,
                                              color: AppColors.primaryText,
                                            ),
                                            title: Text(
                                              'Upload an image',
                                              style: TextStyle(
                                                  color: AppColors.primaryText),
                                            ),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              setState(() {
                                                _isImageLoading = true;
                                              });
                                              await pickAndUploadImage();
                                              await loadImage();
                                            },
                                          ),
                                          ListTile(
                                            leading: SvgPicture.asset(
                                              'assets/svg/delete.svg',
                                              width: 24,
                                              height: 24,
                                              color: (imageUrl == null ||
                                                      imageUrl!.isEmpty)
                                                  ? Colors.grey
                                                  : AppColors.primaryText,
                                            ),
                                            title: Text(
                                              'Delete image',
                                              style: TextStyle(
                                                color: (imageUrl == null ||
                                                        imageUrl!.isEmpty)
                                                    ? Colors.grey
                                                    : AppColors.primaryText,
                                              ),
                                            ),
                                            onTap: (imageUrl == null ||
                                                    imageUrl!.isEmpty)
                                                ? null
                                                : () async {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      _isImageLoading = true;
                                                    });
                                                    await deleteProfileImage();
                                                    await loadImage();
                                                    setState(() {
                                                      _isImageLoading = false;
                                                    });
                                                  },
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  'assets/svg/edit.svg',
                                  height: 18,
                                  width: 18,
                                  colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                UsernameDisplay(
                                  uid: user.uid,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/svg/edit.svg',
                                  height: 18,
                                  width: 18,
                                ),
                              ],
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
                      AwesomeDialog(
                          padding: EdgeInsets.all(12),
                          context: context,
                          dialogType: DialogType.noHeader,
                          dialogBackgroundColor: AppColors.secondaryText,
                          dialogBorderRadius: BorderRadius.circular(15),
                          animType: AnimType.scale,
                          body: StatefulBuilder(builder: (context, setState) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Update your username below',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      'This name will be used across your account and may be visible to others.'),
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
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      side: BorderSide(
                                        color: Color(0xFFD9D9D9),
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                                        borderRadius: BorderRadius.circular(12),
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
                              ),
                            );
                          })).show();
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('************',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                    )),
                                SvgPicture.asset(
                                  'assets/svg/edit.svg',
                                  height: 18,
                                  width: 18,
                                ),
                              ],
                            )),
                      ],
                    ),
                    onTap: () async{
                      AwesomeDialog(
                          padding: EdgeInsets.all(12),
                          context: context,
                          dialogType: DialogType.noHeader,
                          dialogBackgroundColor: AppColors.secondaryText,
                          dialogBorderRadius: BorderRadius.circular(15),
                          animType: AnimType.scale,
                          body: StatefulBuilder(builder: (context, setState) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Change your Password',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      'Please enter your email and you will receive an email with a link to change your password.'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: _emailcontroller,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      label: Text('Enter your email'),
                                      labelStyle: TextStyle(
                                          color: errorText != null
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .error
                                              : Colors.black),
                                      errorText: errorText,
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      side: BorderSide(
                                        color: Color(0xFFD9D9D9),
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                                          _emailcontroller.text.trim();
                                      if (email.isEmpty) {
                                        setState(() {
                                          errorText = "email can't be empty.";
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
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                          errorText = null;
                                        } catch (e) {
                                          if (e
                                              .toString()
                                              .contains('badly formatted')) {
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
                                  ),
                                  SizedBox(
                                    height: 15,
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
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      fixedSize: Size(250, 45),
                                    ),
                                    onPressed: () {
                                      _emailcontroller.clear();
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
                              ),
                            );
                          })).show();
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  buildButton(
                    // 'Delete Account',
                    S.of(context).delete_Account,
                    AppColors.buttonColor,
                    AppColors.buttonText,
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        dialogBackgroundColor: AppColors.secondaryText,
                        dialogBorderRadius: BorderRadius.circular(15),
                        animType: AnimType.scale,
                        body: StatefulBuilder(builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Are you sure you want to delete your account?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                      'This action cannot be undone.\nAll of your data will be permanently deleted.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
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
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                            );
                        }
                        )
                        ).show();
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
