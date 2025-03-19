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
}) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: AppColors.secondaryText,
      borderRadius: BorderRadius.circular(22),
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
            ),
          ),
        ),
        if (togglePasswordView != null)
          IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black54),
            onPressed: togglePasswordView,
          ),
      ],
    ),
  );
}

Widget buildOrSeparator() {
  return Row(
    children: [
      const Expanded(child: Divider(color: Colors.white, thickness: 1)),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          'or',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      const Expanded(child: Divider(color: Colors.white, thickness: 1)),
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
    height: 50,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondaryText.withOpacity(0.11),
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
    height: 50,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.background,
        side: const BorderSide(color: AppColors.buttonColor),
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
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
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
