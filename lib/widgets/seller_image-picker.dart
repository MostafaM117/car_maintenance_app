import 'package:car_maintenance/Back-end/offer_service.dart';
import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagePickerContainer extends StatefulWidget {
  final Function(String) onImageUploaded;
  const ImagePickerContainer({super.key, required this.onImageUploaded});

  @override
  _ImagePickerContainerState createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  File? _image;
  String? imageUrl;
  final OfferService offerService = OfferService();
  Future<void> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    final File imageFile = File(pickedFile.path);
    final businessName = await offerService.getBusinessName();
    final String fileName = '${businessName}_${path.basename(pickedFile.path)}';
    final storage = Supabase.instance.client.storage;
    const bucket = 'products-images';
    try {
      final existingFiles = await storage.from(bucket).list();
      final fileExists = existingFiles.any((file) => file.name == fileName);
      String? publicUrl;
      if (fileExists) {
        publicUrl = storage.from(bucket).getPublicUrl(fileName);
        print('File already exists: $fileName, reusing URL.');
        setState(() {
          imageUrl = publicUrl;
          _image = imageFile;
        });
        widget.onImageUploaded(publicUrl);
      } else {
        await storage.from(bucket).upload(fileName, imageFile);
        publicUrl = storage.from(bucket).getPublicUrl(fileName);
        print('Image uploaded successfully: $publicUrl');
        setState(() {
          imageUrl = publicUrl;
          _image = imageFile;
        });
        widget.onImageUploaded(publicUrl);
      }
    } catch (e) {
      print('Upload error: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Image',
            style: textStyleWhite.copyWith(
                fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: uploadImage,
          child: Container(
            width: 350,
            height: 133.79,
            decoration: ShapeDecoration(
              color: const Color(0xFFF4F4F4),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: const Color(0xFFD9D9D9),
                ),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: _image == null
                ? Center(
                    child: Text(
                    'Click to  add  image ',
                    style: textStyleGray.copyWith(fontWeight: FontWeight.w400),
                  ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      width: 350,
                      height: 133.79,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
