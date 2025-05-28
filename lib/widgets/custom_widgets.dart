import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/app_colors.dart';

final textStyleWhite = const TextStyle(
  color: AppColors.primaryText,
  fontSize: 18,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
);

final textStyleGray = const TextStyle(
  color: Color(0x7F2C2B33),
  fontSize: 12,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w600,
);

class LocalizedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedText({
    Key? key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: isArabic ? TextAlign.right : TextAlign.left,
    );
  }
}

Widget buildInputField({
  required TextEditingController controller,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
  required String hintText,
  bool obscureText = false,
  VoidCallback? togglePasswordView,
  required Widget iconWidget,
  String? errorText,
  Widget? suffixWidget,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.only(right: 15),
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
        child: Row(
          children: [
            const SizedBox(width: 20),
            iconWidget,
            const SizedBox(width: 18),
            Expanded(
              child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  inputFormatters: inputFormatters,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: textStyleGray,
                    contentPadding: EdgeInsets.only(bottom: 12),
                  ),
                  textAlignVertical: TextAlignVertical.center),
            ),
            if (suffixWidget != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: suffixWidget,
              ),
            if (togglePasswordView != null)
              IconButton(
                icon: SvgPicture.asset(
                  obscureText
                      ? 'assets/svg/eye-see.svg'
                      : 'assets/svg/eye-lock.svg',
                  width: 24,
                  height: 24,
                ),
                onPressed: togglePasswordView,
              ),
          ],
        ),
      ),
      if (errorText != null && errorText.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 4.0),
          child: LocalizedText(
            text: errorText,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
    ],
  );
}

Widget buildOrSeparator(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return Row(
    children: [
      const Expanded(child: Divider(color: Colors.black, thickness: 1)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: LocalizedText(
          text: l10n.orSeparator,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      const Expanded(child: Divider(color: Colors.black, thickness: 1)),
    ],
  );
}

void showErrorDialog(BuildContext context, String message) {
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: LocalizedText(text: l10n.errorDialogTitle),
      content: LocalizedText(text: message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: LocalizedText(text: l10n.okButton),
        ),
      ],
    ),
  );
}

Widget googleButton(VoidCallback onPressed, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return SizedBox(
    width: double.infinity,
    height: 45,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,
        side: const BorderSide(color: AppColors.borderSide),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      icon: Image.asset('assets/images/Google_logo.png', height: 25),
      label: LocalizedText(
        text: l10n.continueWithGoogle,
        style: textStyleWhite,
      ),
      onPressed: onPressed,
    ),
  );
}

Widget buildButton(
  String text,
  Color backgroundColor,
  Color textColor, {
  required VoidCallback? onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 45,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LocalizedText(
            text: text,
            style: textStyleWhite.copyWith(color: textColor),
          ),
        ],
      ),
    ),
  );
}

Widget buildDropdownField({
  String? label,
  required String? value,
  required List<String> options,
  ValueChanged<String?>? onChanged,
  required BuildContext context,
}) {
  final l10n = AppLocalizations.of(context)!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null)
        LocalizedText(
          text: label,
          style: textStyleWhite.copyWith(
              fontSize: 16, fontWeight: FontWeight.w500),
        ),
      SizedBox(
        height: 8,
      ),
      SizedBox(
        width: double.infinity,
        child: Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: LocalizedText(
                text: 'Select',
                style: textStyleGray.copyWith(fontWeight: FontWeight.w400),
              ),
              dropdownColor: AppColors.lightGray,
              iconEnabledColor: AppColors.primaryText,
              style: textStyleGray,
              onChanged: onChanged,
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: LocalizedText(
                    text: option,
                    style: textStyleWhite,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget popUpBotton(String text, Color backgroundColor, Color textColor,
    {required VoidCallback? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    child: LocalizedText(
      text: text,
      style: textStyleWhite.copyWith(fontSize: 16, color: textColor),
    ),
  );
}

Widget buildTextField({
  required String label,
  String? hintText,
  TextEditingController? controller,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      LocalizedText(
        text: label,
        style: textStyleWhite.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textStyleGray.copyWith(fontWeight: FontWeight.w400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: AppColors.borderSide),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: AppColors.borderSide),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: AppColors.buttonColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: textStyleGray,
        validator: validator,
      ),
    ],
  );
}

class ImagePickerContainer extends StatefulWidget {
  const ImagePickerContainer({
    Key? key,
  }) : super(key: key);

  @override
  _ImagePickerContainerState createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => _image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(children: [
            ListTile(
                leading: const Icon(Icons.photo_library),
                title: const LocalizedText(text: 'Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                }),
            ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const LocalizedText(text: 'Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                }),
          ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPickerOptions,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.secondaryText,
          borderRadius: BorderRadius.circular(12),
          image: _image != null
              ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover)
              : null,
        ),
        child: _image == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/image.svg',
                      width: 50,
                      height: 50,
                      color: AppColors.primaryText,
                    ),
                    SizedBox(height: 10),
                    LocalizedText(
                      text: 'Tap to select image',
                      style: textStyleGray.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}

Widget buildAttachmentPicker({
  required Function(File) onAttachmentPicked,
}) {
  return GestureDetector(
    onTap: () async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        onAttachmentPicked(File(image.path));
      }
    },
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.secondaryText,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSide),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.attach_file, color: AppColors.primaryText, size: 30),
            SizedBox(height: 8),
            LocalizedText(
              text: 'Add Attachment',
              style: textStyleGray.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );
}
