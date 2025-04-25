import 'package:car_maintenance/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerContainer extends StatefulWidget {
  const ImagePickerContainer({super.key});

  @override
  _ImagePickerContainerState createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  File? _image;

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
        Text(
          'Image',
          style: textStyleWhite.copyWith(fontSize: 16,fontWeight: FontWeight.w500)
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
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
                ?  Center(child: Text('Click to  add  image ',style:textStyleGray.copyWith(fontWeight: FontWeight.w400),))
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
