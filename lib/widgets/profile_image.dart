import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';

class ProfileImagePicker extends StatefulWidget {
  final Function(File) onImagePicked;

  const ProfileImagePicker({super.key, required this.onImagePicked});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImage();  
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImagePath');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);  
      });
    }
  }
  Future<void> _saveImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profileImagePath', imageFile.path);  
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final imageFile = File(picked.path);
      setState(() {
        _image = imageFile;  
      });
      widget.onImagePicked(imageFile);  
      await _saveImage(imageFile);  
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondaryText,
            border: Border.all(
              color: AppColors.borderSide,
              width: 1,
            ),
            image: _image != null
                ? DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _image == null
              ? Icon(Icons.person, color: Colors.white, size: 50)
              : null,
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.6),
              ),
              padding: const EdgeInsets.all(6),
              child: SvgPicture.asset(
                'assets/svg/edit.svg',
                height: 18,
                width: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
