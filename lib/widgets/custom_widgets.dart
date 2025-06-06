import 'dart:io';
import 'package:car_maintenance/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
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
        padding: EdgeInsets.only(right: 15), //20
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
            const SizedBox(width: 20), //24
            iconWidget,
            const SizedBox(width: 18), // 20
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
          child: Text(
            errorText,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
    ],
  );
}

Widget buildOrSeparator(BuildContext context) {
  return Row(
    children: [
      const Expanded(child: Divider(color: Colors.black, thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          S.of(context).or,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const Expanded(child: Divider(color: Colors.black, thickness: 1)),
    ],
  );
}


void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

Widget googleButton(BuildContext context, VoidCallback onPressed) {
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
      label: Text(S.of(context).with_Google, style: textStyleWhite.copyWith(fontWeight: FontWeight.bold)),
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
          Text(text,
              style: textStyleWhite.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              )),
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
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null)
        Text(
          label,
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
              hint: Text('Select ',
                  style: textStyleGray.copyWith(fontWeight: FontWeight.w400)),
              dropdownColor: AppColors.lightGray,
              iconEnabledColor: AppColors.primaryText,
              style: textStyleGray,
              onChanged: onChanged,
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option, style: textStyleWhite),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildTextField({
  TextEditingController? controller,
  List<TextInputFormatter>? inputFormatters,
  String? hintText,
  String? label,
  String? Function(dynamic value)? validator,
  bool enabled = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null)
        Text(
          label,
          style: textStyleWhite.copyWith(
              fontSize: 16, fontWeight: FontWeight.w500),
        ),
      SizedBox(height: 8),
      Container(
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
        alignment: Alignment.center,
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: inputFormatters,
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            border: InputBorder.none,
            isCollapsed: true,
            hintText: hintText,
            hintStyle: textStyleGray.copyWith(fontWeight: FontWeight.w400),
          ),
          style: textStyleGray,
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    ],
  );
}

Widget popUpBotton(
  String text,
  Color backgroundColor,
  Color textColor, {
  required VoidCallback? onPressed,
}) {
  return SizedBox(
    width: 100,
    height: 45,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: FittedBox(
        child: Text(text,
            style: textStyleWhite.copyWith(
              fontSize: 18,
              color: textColor,
            )),
      ),
    ),
  );
}

Widget buildAttachmentPicker({
  required Function(File) onAttachmentPicked,
  String label = 'Attachments',
  File? selectedFile,
  Function()? onClear,
}) {
  return StatefulBuilder(builder: (context, setState) {
    final ImagePicker picker = ImagePicker();

    Future<void> pickAttachment() async {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final file = File(picked.path);
        setState(() {
          selectedFile = file;
        });
        onAttachmentPicked(file);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyleWhite.copyWith(
              fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: pickAttachment,
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      selectedFile != null
                          ? selectedFile!.path.split('/').last
                          : 'Add attachments',
                      style: textStyleGray,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                // if (selectedFile != null)
                //   IconButton(
                //     icon: Icon(Icons.clear, color: Colors.grey),
                //     onPressed: () {
                //       setState(() {
                //         selectedFile = null;
                //       });
                //       if (onClear != null) onClear();
                //     },
                //     padding: EdgeInsets.zero,
                //     constraints: BoxConstraints(),
                //   ),
              ],
            ),
          ),
        ),
      ],
    );
  });
}
