import 'dart:io';

import 'package:car_maintenance/screens/Auth_and_Account%20Management/redirecting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        'seller_data_completed': true,
      });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RedirectingPage()),
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
      
    );
  }
}