import 'dart:io';

import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/get_shop_location.dart';
import 'package:car_maintenance/screens/Terms_and_conditionspage%20.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompleteSellerInfo extends StatefulWidget {
  final String businessname;
  final String businessemail;
  final String password;
  final String nationalID;

  const CompleteSellerInfo({
    super.key, 
    required this.businessname, 
    required this.businessemail,
    required this.password,
    required this.nationalID,
    });

  @override
  State<CompleteSellerInfo> createState() => _CompleteSellerInfoState();
}

class _CompleteSellerInfoState extends State<CompleteSellerInfo> {
  final _taxsnumbercontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _locationController = TextEditingController();
  final _idimagesController = TextEditingController();
  bool _termschecked = false;
  bool _isLoading = false;
  LatLng? shoplocation ;
  String? idImageUrl1;
  String? idImageUrl2;

  //Finish Signing up Function
  Future<UserCredential?> finishSignup() async {
    final taxsnumber = _taxsnumbercontroller.text.trim();
    final phonenumber = _phonenumbercontroller.text.trim();
    final location = _locationController.text.trim();
    if (taxsnumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your tax registration number')),
      );
      return null;
    }
    if (taxsnumber.length != 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid tax registration number')),
      );
      return null;
    }
    else if (phonenumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your phone number')),
      );
      return null;
    }
    else if (phonenumber.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please a valid phone number')),
      );
      return null;
    }
    else if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your location')),
      );
      return null;
    }
    else if (idImageUrl1 == null || idImageUrl2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload the front and back sides of your national ID')),
      );
      return null;
    }
    else {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: widget.businessemail,
                password: widget.password);

        await createuser(
          widget.businessname,
          widget.businessemail,
          widget.nationalID,
          userCredential.user!.uid,
          idImageUrl1!,
          idImageUrl2!,
        );
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Registred Successfully'),
            duration: Duration(milliseconds: 4000),
            backgroundColor: Colors.green.shade400,
          ),
        );
        return userCredential;
      } catch (e) {
        if (e.toString().contains('email-already-in-use')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('This email is already registered')),
          );
          return null;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
          return null;
        }
      }
      finally {
        // Hide loader
        if (mounted) {
        setState(() {
          _isLoading = false;
        });
        }
      }
    }
  }

  Future createuser(String businessname, String email, String nationalID, String uid, String idImageUrl1,
  String idImageUrl2) async {
    await FirebaseFirestore.instance.collection('sellers').doc(uid).set({
      'business_name': businessname,
      'email': email,
      'National_ID': nationalID,
      'uid': uid,
      'tax_registration_number': _taxsnumbercontroller.text.trim(),
      'phone_number': _phonenumbercontroller.text.trim(),
      // 'password': _passwordcontroller.text.trim(),
      'role': 'seller',
      'googleUser': false,
      'id_image1': idImageUrl1,
      'id_image2': idImageUrl2,
      'shoplocation' : {
        'lat' : shoplocation!.latitude,
        'lng' : shoplocation!.longitude,
      },
      'seller_data_completed': true,
      'store_verified': false,
    });
  }

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final List <XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles == null || pickedFiles.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select the front and back sides of your national ID')),
      );
      return;
    }
    else if (pickedFiles.length > 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can\'t upload more than 2 images'), backgroundColor: Colors.red,),
      );
      return;
    }

    final storage = Supabase.instance.client.storage;
    const bucket = 'seller-id-images';
    List<String> urls =[];
    try {
      List<String> imageNames = [];
      for(var i = 0; i < 2; i++){
        final pickedFile = pickedFiles[i];
        final file = File(pickedFile.path);
        final fileName = '${DateTime.now().microsecondsSinceEpoch}_${path.basename(pickedFile.path)}';
        imageNames.add(path.basename(pickedFile.path)); 
        await storage.from(bucket).upload(fileName, file);
        final publicUrl = storage.from(bucket).getPublicUrl(fileName);
        urls.add(publicUrl);
      }
      setState(() {
        idImageUrl1 = urls[0];
        idImageUrl2 = urls[1];
        _idimagesController.text = imageNames.join(', ');
      });
      print('ID images uploaded.');
    } catch (e) {
      print('Upload error: $e');
    }
  }

  @override
  void dispose() {
    _idimagesController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.black)) 
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                l10n.completeBusinessInfo,
                style: textStyleWhite.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.completeBusinessInfoDescription,
                style: textStyleGray.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              buildInputField(
                controller: _taxsnumbercontroller,
                iconWidget: SvgPicture.asset(
                  'assets/svg/tax.svg',
                  width: 24,
                  height: 24,
                ),
                hintText: l10n.taxNumberHint,
              ),
              const SizedBox(height: 20),
              buildInputField(
                controller: _phonenumbercontroller,
                iconWidget: SvgPicture.asset(
                  'assets/svg/phone.svg',
                  width: 24,
                  height: 24,
                ),
                hintText: l10n.phoneNumberHint,
              ),
              const SizedBox(height: 20),
              buildInputField(
                controller: _locationController,
                iconWidget: SvgPicture.asset(
                  'assets/svg/location.svg',
                  width: 24,
                  height: 24,
                ),
                hintText: l10n.locationHint,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.uploadIdImages,
                style: textStyleWhite.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Upload front ID image
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/upload.svg',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.frontIdImage,
                                style: textStyleGray,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Upload back ID image
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/upload.svg',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.backIdImage,
                                style: textStyleGray,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              buildButton(
                l10n.completeRegistration,
                AppColors.buttonColor,
                AppColors.buttonText,
                onPressed: () {
                  finishSignup();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}