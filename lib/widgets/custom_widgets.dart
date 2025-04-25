import 'package:flutter/material.dart';
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
        child: Row(
          children: [
            const SizedBox(width: 24),
            iconWidget,
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                  controller: controller,
                  obscureText: obscureText,
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
                icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54),
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

Widget buildOrSeparator() {
  return Row(
    children: [
      const Expanded(child: Divider(color: Colors.black, thickness: 1)),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'or',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
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

Widget googleButton(VoidCallback onPressed) {
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
      label: Text('Continue with Google', style: textStyleWhite),
      onPressed: onPressed,
    ),
  );
}

Widget appleButton(VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    height: 45,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,
        side: const BorderSide(color: AppColors.borderSide),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      icon: Icon(
        Icons.apple,
        color: Colors.white,
        size: 30,
      ),
      label: Text('Continue with Apple', style: textStyleWhite),
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
          Text(text, style: textStyleWhite.copyWith(color: textColor)),
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
          style: textStyleWhite.copyWith(fontSize: 16,fontWeight: FontWeight.w500),
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
  String? hintText,
  String? label,
  String? Function(dynamic value)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label != null)
        Text(
          label,
          style: textStyleWhite.copyWith(fontSize: 16,fontWeight: FontWeight.w500),
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
          controller: controller,
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

Widget buildUserNameField({
  required TextEditingController controller,
  required bool isEditing,
  required String? Function(String? value) validator,
}) {
  if (isEditing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            controller: controller,
            enabled: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              prefixStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              // prefixText: 'username: ',
              isCollapsed: true,
            ),
            style: textStyleGray,
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
      ],
    );
  } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          height: 45,
          // decoration: ShapeDecoration(
          //   color: AppColors.secondaryText,
          //   shape: RoundedRectangleBorder(
          //     side: BorderSide(
          //       width: 1,
          //       color: AppColors.borderSide,
          //     ),
          //     borderRadius: BorderRadius.circular(22),
          //   ),
          // ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: TextField(
            controller: controller,
            enabled: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixStyle: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              prefixText: 'username: ',
              isCollapsed: true,
            ),
            style: textStyleGray,
            // textAlignVertical: TextAlignVertical.center,
          ),
        ),
      ],
    );
  }
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
