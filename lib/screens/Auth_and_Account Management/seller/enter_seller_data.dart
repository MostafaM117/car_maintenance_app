import 'dart:io';
import 'package:car_maintenance/constants/app_colors.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/get_shop_location.dart';
import 'package:car_maintenance/screens/Auth_and_Account%20Management/seller/store_not_verified.dart';
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

class EnterSellerData extends StatefulWidget {
  const EnterSellerData({super.key});

  @override
  State<EnterSellerData> createState() => _EnterSellerDataState();
}

class _EnterSellerDataState extends State<EnterSellerData> {

  final _nationalIDcontroller = TextEditingController();
  final _taxsnumbercontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _locationController = TextEditingController();
  final _idimagesController = TextEditingController();
  bool _termschecked = false;
  bool _isLoading = false;
  LatLng? shoplocation ;
  String? idImageUrl1;
  String? idImageUrl2;
  final seller = FirebaseAuth.instance.currentUser!;

  //Finish Signing up with Google
  Future<UserCredential?> finishSignupWithGoogle() async {
    final nationalID = _nationalIDcontroller.text.trim();
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
        await FirebaseFirestore.instance.collection('sellers').doc(seller.uid).update({
        'National_ID': nationalID,
        'tax_registration_number': taxsnumber,
        'phone_number': phonenumber,
        'id_image1': idImageUrl1,
        'id_image2': idImageUrl2,
        'seller_data_completed': true,
        'shoplocation' : {
        'lat' : shoplocation!.latitude,
        'lng' : shoplocation!.longitude,
        },
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => StoreNotVerified()),
          (route) => false);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content:
        //         Text('Data Completed Successfully'),
        //     duration: Duration(milliseconds: 4000),
        //     backgroundColor: Colors.green.shade400,
        //   ),
        // );
      } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
          return null;
        
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
    return null;
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
                'Complete your business account details',
                style: textStyleGray.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              // National ID
              buildInputField(
                iconWidget: Icon(Icons.person_pin_outlined),
                controller: _nationalIDcontroller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(14),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                hintText: 'Enter your national id number',
              ),
              SizedBox(height: 20,),
              // Tax Registration Number 
              buildInputField(
                iconWidget: Icon(Icons.person_pin_outlined),
                controller: _taxsnumbercontroller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(9),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                hintText: 'Enter your tax registration number',
              ),
              SizedBox(height: 20,),
              // Phone number
              buildInputField(
                iconWidget: Icon(Icons.phone),
                controller: _phonenumbercontroller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(11),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                hintText: 'Enter your business phone number',
              ),
              SizedBox(height: 20,),
              // Location
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  height: 45,
                  decoration: ShapeDecoration(
                    color: AppColors.secondaryText,
                    shape: RoundedRectangleBorder(
                    side: BorderSide(
                    width: 1,
                    color: AppColors.borderSide,
                    ),
                  borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const SizedBox(width: 20), //24
                      Icon(Icons.location_on_outlined),
                      const SizedBox(width: 18), // 20
                      Expanded(
                        child: TextField(
                          controller: _locationController,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Get your current location',
                            hintStyle: textStyleGray,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 12),
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),)
                    ],
                  ),
                ),
                onTap: () async{
                  FocusScope.of(context).requestFocus(FocusNode());
                  LatLng? selectedLocation = 
                  await Navigator.push(context , MaterialPageRoute(builder: (context)=> GetShopLocation()));
                  if(selectedLocation != null){
                    _locationController.text = '${selectedLocation.latitude},${selectedLocation.longitude}';
                    shoplocation = selectedLocation;
                  }
                },
              ),
              SizedBox(height: 20,),
              // Uploading image
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  height: 45,
                  decoration: ShapeDecoration(
                    color: AppColors.secondaryText,
                    shape: RoundedRectangleBorder(
                    side: BorderSide(
                    width: 1,
                    color: AppColors.borderSide,
                    ),
                  borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const SizedBox(width: 20), //24
                      Icon(Icons.image_outlined),
                      const SizedBox(width: 18), // 20
                      Expanded(
                        child: TextField(
                          controller: _idimagesController,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Upload Your Images',
                            hintStyle: textStyleGray,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 12),
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),)
                    ],
                  ),
                ),
                onTap: () {
                  pickAndUploadImage();
                },
              ),
              const SizedBox(height: 15),
              CheckboxListTile(
                  value: _termschecked,
                  title: RichText(
                      text: TextSpan(
                          style: textStyleGray.copyWith(fontSize: 12),
                          children: [
                        const TextSpan(
                            text: 'By signing up, you agree to our '),
                        TextSpan(
                            text: 'Terms of Service and privacy Policy.',
                            style: textStyleGray.copyWith(
                              color: Colors.blue.shade200,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TermsAndConditionsPage()));
                              })
                      ])),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (bool? value) {
                    setState(() {
                      _termschecked = value!;
                    });
                  }),
              const SizedBox(height: 30), //60
              // Signup Button requires terms to be checked
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    _termschecked
                        ? finishSignupWithGoogle()
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Terms of Service must be checked'),),
                                );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        _termschecked ? AppColors.buttonColor : Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Finish Signing up',
                          style: textStyleWhite.copyWith(
                              color: AppColors.buttonText))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}