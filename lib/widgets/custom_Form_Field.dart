import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import 'custom_widgets.dart';

Widget customFormField({
  required TextEditingController controller,
  required String label,
  required String hintText,
  String? Function(String?)? validator,
  List<TextInputFormatter>? inputFormatters,
  TextInputType keyboardType = TextInputType.text,
  bool enabled = true,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: textStyleWhite.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
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
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          enabled: enabled,
          validator: validator,
          decoration: InputDecoration(
            border: InputBorder.none,
            isCollapsed: true,
            hintText: hintText,
            hintStyle: textStyleGray.copyWith(fontWeight: FontWeight.w400),
          ),
          style: textStyleGray,
        ),
      ),
    ],
  );
}
